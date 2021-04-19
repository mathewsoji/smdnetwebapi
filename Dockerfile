FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["smdnetwebapi.csproj", "./"]
RUN dotnet restore "smdnetwebapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "smdnetwebapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "smdnetwebapi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "smdnetwebapi.dll"]

#docker build -t smdnetwebapi:v1 .