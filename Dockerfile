FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
# FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /app

# publish app
COPY src .
WORKDIR /app/Alsa.Samples
RUN dotnet restore -r linux-x64
# copy and publish app and libraries
RUN dotnet publish -c Release -r linux-x64 -o out --self-contained false --no-restore

## run app
#FROM mcr.microsoft.com/dotnet/core/runtime:2.1-stretch-slim-arm32v7 AS runtime
FROM mcr.microsoft.com/dotnet/runtime:6.0-bullseye-slim-amd64
# FROM mcr.microsoft.com/dotnet/core/runtime:2.1 AS runtime
WORKDIR /app
COPY --from=build /app/Alsa.Samples/out ./

# configure apt sources
########################
#        Debian        #
########################mirror.eu.oneandone.net
#RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    #echo "deb https://mirror.eu.oneandone.net/debian/ stretch main contrib non-free" >/etc/apt/sources.list && \
    #echo "deb-src https://mirror.eu.oneandone.net/debian/ stretch main contrib non-free" >>/etc/apt/sources.list && \
    #echo "deb https://mirror.eu.oneandone.net/debian/ stretch-updates main contrib non-free" >>/etc/apt/sources.list && \
    #echo "deb-src https://mirror.eu.oneandone.net/debian/ stretch-updates main contrib non-free" >>/etc/apt/sources.list && \
    #echo "deb https://mirror.eu.oneandone.net/debian/ stretch-backports main contrib non-free" >>/etc/apt/sources.list && \
    #echo "deb-src https://mirror.eu.oneandone.net/debian/ stretch-backports main contrib non-free" >>/etc/apt/sources.list && \
    #echo "deb https://mirror.eu.oneandone.net/debian-security stretch/updates main contrib non-free" >>/etc/apt/sources.list && \
    #echo "deb-src https://mirror.eu.oneandone.net/debian-security stretch/updates main contrib non-free" >>/etc/apt/sources.list

########################
#       Raspbian       #
########################
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
#     echo "deb http://mirror.eu.oneandone.net/raspbian/raspbian/ stretch main non-free contrib" >/etc/apt/sources.list && \
#     echo "deb-src http://mirror.eu.oneandone.net/raspbian/raspbian/ stretch main non-free contrib" >>/etc/apt/sources.list

# install native dependencies
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated libasound2-dev && \
    rm -rf /var/lib/apt/lists/*

CMD bash
#ENTRYPOINT ["dotnet", "Alsa.Samples.dll"]