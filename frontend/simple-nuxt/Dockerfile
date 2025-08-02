FROM node:20-alpine as build

ARG PORT=3000

WORKDIR /src

COPY . .

RUN npm install -g pnpm
RUN pnpm add "@popperjs/core"@"/@sxzz/popperjs-es@2.11.7"
RUN pnpm install
RUN pnpm build

# Run
FROM node:20-alpine

ENV PORT=$PORT

WORKDIR /src

LABEL MAINTAINER="yuansu.china.work@gmail.com"

COPY --from=build /src/.output /src/.output
# Optional, only needed if you rely on unbundled dependencies
# COPY --from=build /src/node_modules /src/node_modules

CMD [ "node", ".output/server/index.mjs" ]