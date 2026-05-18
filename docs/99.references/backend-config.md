# 백엔드 설정 참조

## application.yml 기본 설정

파일 위치: `backend/src/main/resources/application.yml`

```yaml
spring:
  application:
    name: wms-backend
  datasource:
    url: ${SPRING_DATASOURCE_URL:jdbc:postgresql://db.yonghee.net:5532/wmsdb}
    username: ${SPRING_DATASOURCE_USERNAME:wms_developer}
    password: ${SPRING_DATASOURCE_PASSWORD:wmspassword1234}

mybatis:
  mapper-locations: classpath:mapper/**/*.xml
  configuration:
    map-underscore-to-camel-case: false

# Springdoc OpenAPI (Swagger UI). 운영 배포 시 비활성: SPRINGDOC_SWAGGER_UI_ENABLED=false
springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html
    try-it-out-enabled: true
    operations-sorter: alpha
    tags-sorter: alpha
```

---

## SecurityConfig (CORS 전용)

프론트엔드(Live Server 등)와 백엔드가 다른 포트에서 실행되므로 CORS 허용이 필요하다. 인증/인가 로직은 포함하지 않는다.

### 파일 위치

`backend/src/main/java/com/execnt/wms/config/SecurityConfig.java`

### 기본 코드

```java
package com.execnt.wms.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll()
            );
        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOriginPatterns(List.of("*"));
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        config.setAllowedHeaders(List.of("*"));
        config.setAllowPrivateNetwork(Boolean.TRUE);
        config.setAllowCredentials(false);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }
}
```

### 설정 설명

| 설정 | 값 | 이유 |
|------|-----|------|
| allowedOriginPatterns | `*` | Live Server 등 어떤 포트에서든 접근 허용 |
| allowedMethods | GET, POST, PUT, DELETE, OPTIONS | REST API + CORS Preflight |
| allowedHeaders | `*` | Content-Type 등 모든 헤더 허용 |
| allowPrivateNetwork | `true` | Chrome Private Network Access Preflight 대응 |
| allowCredentials | `false` | 인증 쿠키 불필요 (JWT/세션 없음) |
| csrf.disable() | — | REST API에서 CSRF 보호 불필요 |
| anyRequest().permitAll() | — | 인증 없이 전체 API 접근 허용 |

### build.gradle 의존성

SecurityConfig를 사용하려면 build.gradle에 Spring Security 의존성이 필요하다.

```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-security'
}
```

### 주의사항

- 이 SecurityConfig는 CORS 허용 전용이다. 인증/로그인/JWT 관련 코드를 추가하지 않는다
- allowedOriginPatterns("*")는 교육용 설정이다. 운영 환경에서는 허용 Origin을 명시해야 한다
- 백엔드 포트를 변경하면 프론트엔드 api.js의 API_BASE도 함께 수정해야 한다
