# Use Alpine Linux as the base image
FROM alpine:latest

# Set environment variable for Nginx version
ARG NGINX_VERSION=1.27.0

# Install necessary packages
RUN apk update && \
    apk add --no-cache wget git gcc make g++ zlib-dev linux-headers pcre-dev openssl-dev

# Download and extract Nginx
RUN cd /opt && \
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar xzf nginx-${NGINX_VERSION}.tar.gz

# Clone the ngx_http_substitutions_filter_module repository
RUN git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git /opt/ngx_http_substitutions_filter_module

# Build and install Nginx with the custom module
RUN cd /opt/nginx-${NGINX_VERSION} && \
    ./configure --add-module=/opt/ngx_http_substitutions_filter_module/ && \
    make && \
    make install

# Clean up
RUN rm -rf /opt/nginx-${NGINX_VERSION} /opt/nginx-${NGINX_VERSION}.tar.gz /opt/ngx_http_substitutions_filter_module

# Start Nginx
CMD ["/usr/local/nginx/sbin/nginx"]
