FROM mhart/alpine-node:latest
WORKDIR /app
ENV NODE_ENV=production
COPY package.json yarn.lock ./
COPY FrontEnd /app/FrontEnd/
RUN yarn && yarn next build ./FrontEnd

FROM alpine:3.7
ENV NODE_ENV=production
COPY --from=0 /usr/bin/node /usr/bin/
COPY --from=0 /usr/lib/libgcc* /usr/lib/libstdc* /usr/lib/
WORKDIR /app
COPY --from=0 /app/FrontEnd/.next/ ./FrontEnd/.next/
COPY --from=0 /app/node_modules/ ./node_modules/
COPY entrypoint.js ./
EXPOSE 80
CMD ["node", "/app/entrypoint.js"]
