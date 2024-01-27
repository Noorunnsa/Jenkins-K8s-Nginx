
FROM alpine:latest
RUN apk update


RUN apk add --no-cache nginx

#nginxconf
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /usr/share/doc/nginx/html


COPY index.html /usr/share/doc/nginx/html/index.html

# Expose Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
