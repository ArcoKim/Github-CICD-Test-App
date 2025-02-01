FROM public.ecr.aws/docker/library/gradle:jdk17-alpine AS builder

WORKDIR /

COPY *.gradle .
COPY src src

RUN gradle clean build -x test --no-daemon

FROM public.ecr.aws/docker/library/amazoncorretto:17-alpine

WORKDIR /app

RUN apk --no-cache add curl

COPY --from=builder /build/libs/*.jar app.jar

CMD ["java","-jar","./app.jar"]