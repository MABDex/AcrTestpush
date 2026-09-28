package org.example.testacr;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;

@SpringBootApplication
public class TestAcrApplication {

    public static void main(String[] args) {
        SpringApplication.run(TestAcrApplication.class, args);
    }
    @GetMapping("/")
    public String hello() {
        return "Spring Boot App laeuft!";
    }
}
