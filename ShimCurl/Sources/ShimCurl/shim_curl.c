#include <shim_curl.h>
#include <curl/curl.h>
#include <string.h>
#include <stdlib.h>

// MARK: Declarations

CURL *curl;
CURLcode res;

struct response_buffer {
    char *ptr;
    size_t len;
};

void set_url(CURL *curl, SimpleHttpRequest *request);
void set_method(CURL *curl, SimpleHttpRequest *request);
void set_headers(CURL *curl, SimpleHttpRequest *request);
void set_body(CURL *curl, SimpleHttpRequest *request);

// Callbacks
void init_buffer(struct response_buffer *buffer);
size_t writefunc(void *ptr, size_t size, size_t nmemb, struct response_buffer *buffer);

// MARK: Implementations

void shim_curl_version() {
    printf("Curl Version: %s\n", curl_version());
}

void shim_curl_init() {
    curl_global_init(CURL_GLOBAL_DEFAULT);
}

void shim_curl_request(SimpleHttpRequest * request, SimpleHttpResponse * response) {
    curl = curl_easy_init();
    if(curl) {

        // Prepare request
        set_url(curl, request);
        set_method(curl, request);
        set_headers(curl, request);
        set_body(curl, request);
        
        // Setup buffers for getting response
        struct response_buffer body_buffer;
        struct response_buffer headers_buffer;
        init_buffer(&body_buffer);
        init_buffer(&headers_buffer);
        
        //Setup callbacks
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writefunc);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &body_buffer);
        curl_easy_setopt(curl, CURLOPT_HEADERFUNCTION, writefunc);
        curl_easy_setopt(curl, CURLOPT_HEADERDATA, &headers_buffer);
        
        // Make request
        res = curl_easy_perform(curl);
        if(res != CURLE_OK) {
            const char *curl_error = curl_easy_strerror(res);
            char *buffer = (char *)malloc(sizeof(char) * (strlen(curl_error) + 1));
            strcpy(buffer, curl_error);
            
            response->status_code = -1;
            response->bytes = buffer;
        }
        
        // Get status code of the request
        long response_code;
        curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
        
        // Custruct response
        response->status_code = (int)response_code;
        response->headers = (char *)malloc(sizeof(char) * (strlen(headers_buffer.ptr) + 1));
        response->bytes = (char *)malloc(sizeof(char) * (strlen(body_buffer.ptr) + 1));
        response->num_headers_bytes = strlen(headers_buffer.ptr);
        response->num_bytes = strlen(body_buffer.ptr);
        strcpy(response->headers, headers_buffer.ptr);
        strcpy(response->bytes, body_buffer.ptr);
    
        // Free the buffers
        free(body_buffer.ptr);
        free(headers_buffer.ptr);
        
        curl_easy_cleanup(curl);
    } else {
        const char *curl_error = "Curl not initialized.";
        char *buffer = (char *)malloc(sizeof(char) * (strlen(curl_error) + 1));
        strcpy(buffer, curl_error);
        
        response->status_code = -1;
        response->bytes = buffer;
    }
}

void set_url(CURL *curl, SimpleHttpRequest *request) {
    curl_easy_setopt(curl, CURLOPT_URL, request->url);
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
}

void set_method(CURL *curl, SimpleHttpRequest *request) {
    switch (request->method) {
        case GET:
            curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
            break;
        case POST:
            curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
            break;
        case PUT:
            curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT");
            break;
        case UPDATE:
            curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "UPDATE");
            break;
        case DELETE:
            curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "DELETE");
            break;
    }
}

void set_headers(CURL *curl, SimpleHttpRequest *request) {
    if(request->num_headers > 0) {
        struct curl_slist *chunk = NULL;
        for(int i = 0; i < request->num_headers; i++) {
            chunk = curl_slist_append(chunk, (request->headers)[i]);
        }
        
        /* set our custom set of headers */
        res = curl_easy_setopt(curl, CURLOPT_HTTPHEADER, chunk);
    }
}

void set_body(CURL *curl, SimpleHttpRequest *request) {
    if (request->num_bytes > 0) {
        res = curl_easy_setopt(curl, CURLOPT_POSTFIELDS, request->bytes);
    }
}

void shim_curl_clean() {
    curl_global_cleanup();
}

void init_buffer(struct response_buffer *buffer) {
    buffer->len = 0;
    buffer->ptr = malloc(buffer->len + 1);
    if (buffer->ptr == NULL) {
        fprintf(stderr, "malloc() failed\n");
        exit(EXIT_FAILURE);
    }
    
    buffer->ptr[0] = '\0';
}

size_t writefunc(void *ptr, size_t size, size_t nmemb, struct response_buffer *buffer) {
    size_t new_len = buffer->len + size * nmemb;
    buffer->ptr = realloc(buffer->ptr, new_len + 1);
    
    if (buffer->ptr == NULL) {
        fprintf(stderr, "realloc() failed\n");
        exit(EXIT_FAILURE);
    }
    
    memcpy(buffer->ptr + buffer->len, ptr, size * nmemb);
    buffer->ptr[new_len] = '\0';
    buffer->len = new_len;
    
    return size * nmemb;
}
