package com.sysage.validation;

import com.sysage.core.CoreConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 *
 * Spring boot application start up
 *
 * @author wilson.jian
 * @date 2018/4/2
 * @since 1.0
 *
 */
@SpringBootApplication
public class ServerApplication extends CoreConfiguration {
    public static void main(String[] args) {
        SpringApplication.run(ServerApplication.class, args);
    }
}
