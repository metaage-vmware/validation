package com.sysage.validation;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import com.sysage.web.model.request.MessageFilter;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;

/**
 *
 * Created by IDEA Template
 *
 * @author wilson.jian
 * @date 2022/10/27
 * @since 1.0
 */

@JsonPropertyOrder({"filter", "data"})
public class RqBody<T> {
    private T data;

    @Valid
    public T getData() {
        return this.data;
    }

    public void setData(T data) {
        this.data = data;
    }

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private MessageFilter filter;

    public RqBody() {
    }

    public RqBody(T data) {
        this.data = data;
    }

    public RqBody(@NotNull MessageFilter filter) {
        this(filter, null);
    }

    public RqBody(@NotNull MessageFilter filter, T data) {
        this(data);
        this.filter = filter;
    }

    public MessageFilter getFilter() {
        return this.filter;
    }

    public void setFilter(MessageFilter filter) {
        this.filter = filter;
    }
}
