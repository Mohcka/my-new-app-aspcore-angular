FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://*:5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
RUN apt-get install -y curl \
  && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh
WORKDIR /src
COPY ["my-new-app.csproj", "./"]
RUN dotnet restore "./my-new-app.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "my-new-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "my-new-app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "my-new-app.dll"]
