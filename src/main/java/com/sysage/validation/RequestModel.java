package com.sysage.validation;

import com.sysage.web.model.request.RqBody;

import javax.validation.Valid;

/**
 *
 * Created by IDEA Template
 *
 * @author wilson.jian
 * @date 2022/10/27
 * @since 1.0
 */
public class RequestModel<T> extends RqBody<T> {
    @Valid
    @Override
    public T getData() {
        return super.getData();
    }
}
