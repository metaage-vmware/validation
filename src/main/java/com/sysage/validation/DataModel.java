package com.sysage.validation;

import javax.validation.constraints.Max;
import javax.validation.constraints.NotBlank;

/**
 *
 * Created by IDEA Template
 *
 * @author wilson.jian
 * @date 2022/10/27
 * @since 1.0
 */
public class DataModel {
    @Max(value = 5, message = "value should not less than 5")
    private String value;
    @NotBlank(message = "not blank!")
    private String test;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getTest() {
        return test;
    }

    public void setTest(String test) {
        this.test = test;
    }
}
