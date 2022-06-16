ARG TAG
FROM nginx:${TAG}

ARG USER_ID
ARG GROUP_ID

#RUN echo userId:${USER_ID} && echo groupId:${GROUP_ID} && usermod -u ${USER_ID} nginx && groupmod -g ${GROUP_ID} nginx
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then usermod -u ${USER_ID} nginx && groupmod -g ${GROUP_ID} nginx;fi

STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]


