# FROM gcr.io/distroless/nodejs20
FROM node:22-slim AS BASE
# install dependencies into temp directory
# this will cache them and speed up future builds
# FROM base AS install
# RUN mkdir -p /temp/dev
# COPY package.json bun.lockb /temp/dev/
# RUN cd /temp/dev && bun install --frozen-lockfile
#
# # install with --production (exclude devDependencies)
# RUN mkdir -p /temp/prod
# COPY package.json bun.lockb /temp/prod/
# RUN cd /temp/prod && bun install --frozen-lockfile --production
#
# # copy node_modules from temp directory
# # then copy all (non-ignored) project files into the image
# FROM base AS prerelease
# COPY --from=install /temp/dev/node_modules node_modules
# COPY . .

# [optional] tests & build
ENV NODE_ENV=production
# RUN bun test
# RUN bun run build

# copy production dependencies and source code into final image
# FROM base AS release
# COPY --from=install /temp/prod/node_modules node_modules
# COPY --from=prerelease /usr/src/app/index.ts .
# COPY --from=prerelease /usr/src/app/package.json .

WORKDIR /i
RUN echo '{"type":"module"}' > package.json
ADD node_modules/uWebSockets.js/uws.js node_modules/uWebSockets.js/
ADD node_modules/uWebSockets.js/ESM_wrapper.mjs node_modules/uWebSockets.js/
ADD node_modules/uWebSockets.js/*.node node_modules/uWebSockets.js/
ADD node_modules/uWebSockets.js/package.json node_modules/uWebSockets.js/
ADD lib/run.js run.js

RUN ls node_modules/uWebSockets.js/*.node | grep -v $(node -e 'console.log(`${process.platform}_${process.arch}_${process.versions.modules}`)') | xargs rm

FROM node:22-slim 

COPY --from=BASE /i /i
WORKDIR /i
# run the app
# USER bun
EXPOSE 3000/tcp
ENTRYPOINT ["node","run.js"]
