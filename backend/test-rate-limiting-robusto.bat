@echo off
echo ========================================
echo TESTE DE RATE LIMITING ROBUSTO
echo ========================================
echo.

echo [FASE 1] Teste de Rate Limiting Basico
echo =======================================
echo Enviando 50 requisicoes em sequencia rapida...
echo.

powershell -Command "
$successCount = 0
$rateLimitedCount = 0
$errorCount = 0
$times = @()

Write-Host 'Iniciando teste de 50 requisicoes...'
Write-Host ''

for($i = 1; $i -le 50; $i++) {
    $start = Get-Date
    try {
        $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get -TimeoutSec 5
        $end = Get-Date
        $time = ($end - $start).TotalMilliseconds
        $times += $time
        
        if($response.StatusCode -eq 200) {
            $successCount++
            Write-Host \"Req $i`: OK (${time}ms)\" -ForegroundColor Green
        }
    } catch {
        $end = Get-Date
        $time = ($end - $start).TotalMilliseconds
        
        if($_.Exception.Response.StatusCode -eq 429) {
            $rateLimitedCount++
            Write-Host \"Req $i`: RATE LIMITED (${time}ms)\" -ForegroundColor Yellow
        } else {
            $errorCount++
            Write-Host \"Req $i`: ERROR - $($_.Exception.Message)\" -ForegroundColor Red
        }
    }
    
    # Pequena pausa para nao sobrecarregar
    Start-Sleep -Milliseconds 50
}

Write-Host ''
Write-Host '=== RESULTADOS FASE 1 ===' -ForegroundColor Cyan
Write-Host \"Sucessos: $successCount\" -ForegroundColor Green
Write-Host \"Rate Limited: $rateLimitedCount\" -ForegroundColor Yellow  
Write-Host \"Erros: $errorCount\" -ForegroundColor Red

if($times.Count -gt 0) {
    $avgTime = ($times | Measure-Object -Average).Average
    $minTime = ($times | Measure-Object -Minimum).Minimum
    $maxTime = ($times | Measure-Object -Maximum).Maximum
    Write-Host \"Tempo medio: $([math]::Round($avgTime, 2))ms\" -ForegroundColor Cyan
    Write-Host \"Tempo min/max: $([math]::Round($minTime, 2))ms / $([math]::Round($maxTime, 2))ms\" -ForegroundColor Cyan
}
"

echo.
echo [FASE 2] Teste de Rate Limiting com Burst
echo ==========================================
echo Enviando 20 requisicoes simultaneas...
echo.

powershell -Command "
$jobs = @()
$startTime = Get-Date

Write-Host 'Criando 20 jobs simultaneos...'

# Criar jobs simultaneos
for($i = 1; $i -le 20; $i++) {
    $job = Start-Job -ScriptBlock {
        param($id)
        $start = Get-Date
        try {
            $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get -TimeoutSec 10
            $end = Get-Date
            $time = ($end - $start).TotalMilliseconds
            
            return @{
                Id = $id
                Status = 'SUCCESS'
                StatusCode = $response.StatusCode
                Time = $time
            }
        } catch {
            $end = Get-Date
            $time = ($end - $start).TotalMilliseconds
            
            $status = 'ERROR'
            if($_.Exception.Response.StatusCode -eq 429) {
                $status = 'RATE_LIMITED'
            }
            
            return @{
                Id = $id
                Status = $status
                StatusCode = $_.Exception.Response.StatusCode
                Time = $time
                Error = $_.Exception.Message
            }
        }
    } -ArgumentList $i
    
    $jobs += $job
}

Write-Host 'Aguardando conclusao...'

# Aguardar todos os jobs com timeout
$completed = $jobs | Wait-Job -Timeout 30

if($completed.Count -lt $jobs.Count) {
    Write-Host 'Alguns jobs nao completaram no tempo limite' -ForegroundColor Yellow
    $jobs | Stop-Job
}

# Coletar resultados
$results = @()
foreach($job in $jobs) {
    try {
        $result = Receive-Job $job -ErrorAction SilentlyContinue
        if($result) {
            $results += $result
        }
    } catch {
        Write-Host \"Erro ao coletar resultado do job: $($_.Exception.Message)\" -ForegroundColor Red
    }
    Remove-Job $job -Force
}

$endTime = Get-Date
$totalTime = ($endTime - $startTime).TotalSeconds

# Analisar resultados
$successful = ($results | Where-Object { $_.Status -eq 'SUCCESS' }).Count
$rateLimited = ($results | Where-Object { $_.Status -eq 'RATE_LIMITED' }).Count
$errors = ($results | Where-Object { $_.Status -eq 'ERROR' }).Count

Write-Host ''
Write-Host '=== RESULTADOS FASE 2 ===' -ForegroundColor Cyan
Write-Host \"Total de requisicoes: $($results.Count)\"
Write-Host \"Sucessos: $successful\" -ForegroundColor Green
Write-Host \"Rate Limited: $rateLimited\" -ForegroundColor Yellow
Write-Host \"Erros: $errors\" -ForegroundColor Red
Write-Host \"Tempo total: $([math]::Round($totalTime, 2)) segundos\"

if($successful -gt 0) {
    $successfulResults = $results | Where-Object { $_.Status -eq 'SUCCESS' }
    $avgTime = ($successfulResults | Measure-Object -Property Time -Average).Average
    $minTime = ($successfulResults | Measure-Object -Property Time -Minimum).Minimum
    $maxTime = ($successfulResults | Measure-Object -Property Time -Maximum).Maximum
    
    Write-Host \"Tempo medio (sucessos): $([math]::Round($avgTime, 2))ms\" -ForegroundColor Cyan
    Write-Host \"Tempo min/max: $([math]::Round($minTime, 2))ms / $([math]::Round($maxTime, 2))ms\" -ForegroundColor Cyan
    Write-Host \"Throughput: $([math]::Round($successful / $totalTime, 2)) req/s\" -ForegroundColor Cyan
}
"

echo.
echo [FASE 3] Teste de Recuperacao apos Rate Limit
echo ===============================================
echo Aguardando 5 segundos e testando recuperacao...
echo.

timeout /t 5 /nobreak > nul

powershell -Command "
Write-Host 'Testando recuperacao apos rate limit...'
Write-Host ''

$recoveryCount = 0
for($i = 1; $i -le 10; $i++) {
    $start = Get-Date
    try {
        $response = Invoke-WebRequest -Uri 'http://localhost:8080/actuator/health' -Method Get -TimeoutSec 5
        $end = Get-Date
        $time = ($end - $start).TotalMilliseconds
        
        if($response.StatusCode -eq 200) {
            $recoveryCount++
            Write-Host \"Recovery $i`: OK (${time}ms)\" -ForegroundColor Green
        }
    } catch {
        Write-Host \"Recovery $i`: FALHOU - $($_.Exception.Message)\" -ForegroundColor Red
    }
    
    Start-Sleep -Milliseconds 500
}

Write-Host ''
Write-Host '=== RESULTADOS FASE 3 ===' -ForegroundColor Cyan
Write-Host \"Recuperacao: $recoveryCount/10\" -ForegroundColor Green

if($recoveryCount -eq 10) {
    Write-Host 'Sistema recuperou completamente!' -ForegroundColor Green
} elseif($recoveryCount -ge 7) {
    Write-Host 'Sistema recuperou parcialmente' -ForegroundColor Yellow
} else {
    Write-Host 'Sistema com problemas de recuperacao' -ForegroundColor Red
}
"

echo.
echo ========================================
echo TESTE DE RATE LIMITING CONCLUIDO
echo ========================================
echo.
echo Analise:
echo - Fase 1: Teste sequencial para identificar limites
echo - Fase 2: Teste de burst para validar comportamento sob carga
echo - Fase 3: Teste de recuperacao para validar resiliencia
echo.

pause