package com.vynlotaste.config;

import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Slf4j
@Component
public class RateLimitFilter extends OncePerRequestFilter {

    @Autowired
    private Bucket defaultRateLimitBucket;

    @Autowired
    private Bucket authEndpointsRateLimitBucket;

    @Autowired
    private Bucket apiEndpointsRateLimitBucket;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                  FilterChain filterChain) throws ServletException, IOException {
        
        String path = request.getRequestURI();
        String method = request.getMethod();
        
        // Determinar qual bucket usar baseado no endpoint
        Bucket bucket = determineBucket(path, method);
        
        // Verificar se a requisição pode prosseguir
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
        
        if (probe.isConsumed()) {
            // Adicionar headers de rate limit
            response.addHeader("X-Rate-Limit-Remaining", String.valueOf(probe.getRemainingTokens()));
            response.addHeader("X-Rate-Limit-Reset", String.valueOf(probe.getNanosToWaitForRefill() / 1_000_000_000));
            
            filterChain.doFilter(request, response);
        } else {
            // Rate limit excedido
            long waitForRefill = probe.getNanosToWaitForRefill() / 1_000_000_000;
            
            log.warn("Rate limit excedido para {} {} - IP: {}, User-Agent: {}", 
                    method, path, getClientIP(request), request.getHeader("User-Agent"));
            
            response.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            String errorMessage = String.format(
                "{\"error\":\"Rate limit exceeded\",\"message\":\"Too many requests. Please try again in %d seconds.\",\"retryAfter\":%d}",
                waitForRefill, waitForRefill
            );
            
            response.getWriter().write(errorMessage);
            response.addHeader("Retry-After", String.valueOf(waitForRefill));
        }
    }

    private Bucket determineBucket(String path, String method) {
        // Endpoints de autenticação têm limite mais restritivo
        if (isAuthEndpoint(path)) {
            return authEndpointsRateLimitBucket;
        }
        
        // Endpoints da API geral
        if (path.startsWith("/api/")) {
            return apiEndpointsRateLimitBucket;
        }
        
        // Endpoint padrão para outros caminhos
        return defaultRateLimitBucket;
    }

    private boolean isAuthEndpoint(String path) {
        return path.startsWith("/api/v1/auth/") || 
               path.contains("/login") || 
               path.contains("/register") ||
               path.contains("/password-reset");
    }

    private String getClientIP(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIP = request.getHeader("X-Real-IP");
        if (xRealIP != null && !xRealIP.isEmpty()) {
            return xRealIP;
        }
        
        return request.getRemoteAddr();
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        // Não aplicar rate limiting em health checks e métricas
        return path.startsWith("/actuator/health") || 
               path.startsWith("/actuator/metrics") ||
               path.startsWith("/actuator/prometheus");
    }
}
