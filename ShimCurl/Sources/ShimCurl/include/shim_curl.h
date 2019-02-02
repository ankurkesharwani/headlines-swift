#ifndef SHIM_CURL_H
#define SHIM_CURL_H

typedef enum simple_http_request_method {
    GET,
    POST,
    PUT,
    UPDATE,
    DELETE
} Method;

typedef struct simple_http_request {
    Method    method;
    char   *  url;
    char   ** headers;
    int       num_headers;
    char   *  bytes;
    int       num_bytes;
} SimpleHttpRequest;

typedef struct simple_http_response {
    int    status_code;
    char * headers;
    int    num_headers_bytes;
    char * bytes;
    int    num_bytes;
} SimpleHttpResponse;

/**
 Get Curl version used by the app.
 Must be called only once in the lifetime of the program.
 */
void shim_curl_version();

/**
 Global initialization of Curl.
 */
void shim_curl_init();

/**
 Execute an HTTP/HTTPS request provided by the `request` handle. The response of the
 request is provided in the provided `response` handle.
 
 This function does not take ownership of either `request` and `response` and the
 caller is responsible for properly freeing the memory allocated by them.
 
 @param request The request handle.
 @param response The response handle.
 */
void shim_curl_request(SimpleHttpRequest * request, SimpleHttpResponse * response);

/**
 Clean curl.
 Must be called when Curl is no longer required.
 */
void shim_curl_clean();

#endif /* SHIM_CURL_H */
