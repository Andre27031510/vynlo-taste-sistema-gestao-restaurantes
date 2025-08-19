package com.vynlotaste.config;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;

@Configuration
public class RateLimitConfig {

    @Value("${rate-limit.default-limit:100}")
    private int defaultLimit;

    @Value("${rate-limit.auth-endpoints:10}")
    private int authEndpointsLimit;

    @Value("${rate-limit.api-endpoints:1000}")
    private int apiEndpointsLimit;

    @Value("${rate-limit.burst-capacity:200}")
    private int burstCapacity;

    @Bean
    public Bucket defaultRateLimitBucket() {
        return createBucket(defaultLimit, burstCapacity);
    }

    @Bean
    public Bucket authEndpointsRateLimitBucket() {
        return createBucket(authEndpointsLimit, authEndpointsLimit * 2);
    }

    @Bean
    public Bucket apiEndpointsRateLimitBucket() {
        return createBucket(apiEndpointsLimit, burstCapacity);
    }

    private Bucket createBucket(int requestsPerMinute, int burstCapacity) {
        Bandwidth limit = Bandwidth.builder()
                .capacity(burstCapacity)
                .refillGreedy(requestsPerMinute, Duration.ofMinutes(1))
                .build();
        return Bucket.builder()
                .addLimit(limit)
                .build();
    }
}
