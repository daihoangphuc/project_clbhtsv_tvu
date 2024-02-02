#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["website_CLB_HTSV/website_CLB_HTSV.csproj", "website_CLB_HTSV/"]
RUN dotnet restore "website_CLB_HTSV/website_CLB_HTSV.csproj"
COPY . .
WORKDIR "/src/website_CLB_HTSV"
RUN dotnet build "website_CLB_HTSV.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "website_CLB_HTSV.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "website_CLB_HTSV.dll"]