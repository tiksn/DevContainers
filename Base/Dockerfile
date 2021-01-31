FROM mcr.microsoft.com/powershell:debian-10

RUN pwsh -Command Install-Module -Name Pester -Force -AcceptLicense -Scope AllUsers
RUN pwsh -Command Install-Module -Name psake -Force -AcceptLicense -Scope AllUsers
