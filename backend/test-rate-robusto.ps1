Write-Host "========================================" -ForegroundColor Yellow
Write-Host "TESTE DE RATE LIMITING ROBUSTO" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# FASE 1: Teste Sequencial
Write-Host "[FASE 1] Teste Sequencial - 100 requisições" -ForegroundColor Cyan
$successCount = 0
$rateLimitedCount = 0
$errorCount = 0
$times = @()

for($i = 1; $i -le 100; $i++) {
    $start = Get-Date
    try {
        $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get -TimeoutSec 5
        $end = Get-Date
        $time = ($end - $start).TotalMilliseconds
        $times += $time
        
        if($response.StatusCode -eq 200) {
            $successCount++
            if($i % 10 -eq 0) { Write-Host "Req $i`: OK (${time}ms)" -ForegroundColor Green }
        }
    } catch {
        if($_.Exception.Response.StatusCode -eq 429) {
            $rateLimitedCount++
            Write-Host "Req $i`: RATE LIMITED" -ForegroundColor Yellow
        } else {
            $errorCount++
            Write-Host "Req $i`: ERROR" -ForegroundColor Red
        }
    }
    Start-Sleep -Milliseconds 10
}

Write-Host ""
Write-Host "=== RESULTADOS FASE 1 ===" -ForegroundColor Magenta
Write-Host "Sucessos: $successCount" -ForegroundColor Green
Write-Host "Rate Limited: $rateLimitedCount" -ForegroundColor Yellow
Write-Host "Erros: $errorCount" -ForegroundColor Red

if($times.Count -gt 0) {
    $avgTime = ($times | Measure-Object -Average).Average
    Write-Host "Tempo médio: $([math]::Round($avgTime, 2))ms" -ForegroundColor Cyan
}

Write-Host ""

# FASE 2: Teste de Burst
Write-Host "[FASE 2] Teste de Burst - 50 requisições simultâneas" -ForegroundColor Cyan
$jobs = @()
$startTime = Get-Date

for($i = 1; $i -le 50; $i++) {
    $job = Start-Job -ScriptBlock {
        param($id)
        try {
            $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get -TimeoutSec 10
            return @{ Id = $id; Status = 'SUCCESS'; StatusCode = $response.StatusCode }
        } catch {
            $status = if($_.Exception.Response.StatusCode -eq 429) { 'RATE_LIMITED' } else { 'ERROR' }
            return @{ Id = $id; Status = $status; StatusCode = $_.Exception.Response.StatusCode }
        }
    } -ArgumentList $i
    $jobs += $job
}

$jobs | Wait-Job -Timeout 60 | Out-Null
$results = @()
foreach($job in $jobs) {
    $result = Receive-Job $job -ErrorAction SilentlyContinue
    if($result) { $results += $result }
    Remove-Job $job -Force
}

$endTime = Get-Date
$totalTime = ($endTime - $startTime).TotalSeconds

$successful = ($results | Where-Object { $_.Status -eq 'SUCCESS' }).Count
$rateLimited = ($results | Where-Object { $_.Status -eq 'RATE_LIMITED' }).Count
$errors = ($results | Where-Object { $_.Status -eq 'ERROR' }).Count

Write-Host ""
Write-Host "=== RESULTADOS FASE 2 ===" -ForegroundColor Magenta
Write-Host "Sucessos: $successful" -ForegroundColor Green
Write-Host "Rate Limited: $rateLimited" -ForegroundColor Yellow
Write-Host "Erros: $errors" -ForegroundColor Red
Write-Host "Tempo total: $([math]::Round($totalTime, 2))s"
Write-Host "Throughput: $([math]::Round($successful / $totalTime, 2)) req/s" -ForegroundColor Cyan

Write-Host ""

# FASE 3: Teste de Recuperação
Write-Host "[FASE 3] Teste de Recuperação - Aguardando 10s..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

$recoveryCount = 0
for($i = 1; $i -le 20; $i++) {
    try {
        $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get -TimeoutSec 5
        if($response.StatusCode -eq 200) {
            $recoveryCount++
            if($i % 5 -eq 0) { Write-Host "Recovery $i`: OK" -ForegroundColor Green }
        }
    } catch {
        Write-Host "Recovery $i`: FALHOU" -ForegroundColor Red
    }
    Start-Sleep -Milliseconds 200
}

Write-Host ""
Write-Host "=== RESULTADOS FASE 3 ===" -ForegroundColor Magenta
Write-Host "Recuperação: $recoveryCount/20" -ForegroundColor Green

if($recoveryCount -ge 18) {
    Write-Host "✅ Sistema recuperou completamente!" -ForegroundColor Green
} elseif($recoveryCount -ge 15) {
    Write-Host "⚠️ Sistema recuperou parcialmente" -ForegroundColor Yellow
} else {
    Write-Host "❌ Sistema com problemas de recuperação" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "TESTE ROBUSTO CONCLUÍDO" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

Read-Host "Pressione Enter para continuar"