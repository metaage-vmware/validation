package com.sysage.validation;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

/**
 *
 * Created by IDEA Template
 *
 * @author wilson.jian
 * @date 2022/10/27
 * @since 1.0
 */
@Validated
@RestController
public class ValidController {
    @GetMapping({"/", ""})
    public String index() {
        return "validation server up!";
    }

    @PostMapping("/test")
    public String test(@RequestBody @Valid RequestModel<DataModel> body) {
        return body.getData().getValue();
    }
}
