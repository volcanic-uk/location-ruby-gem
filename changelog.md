# Changelog

All notable changes to Volcanic Location will be documented in this file.
Release date format: DD/MM/YYYY

## [1.1.14] - 13/11/2026
### Security
- `Search` logs one summary line per search (status, result count, duration, path and params) instead of the whole Faraday response. The response's inspect output included the request headers, so every search logged the Location Service bearer token, and its body made log lines of up to 0.8 MiB.
- The Faraday request logger no longer logs request or response headers. Retried requests logged the `Authorization` header.

## [1.1.12] - 06/11/2025
### Fixed
- Fixed location creation by properly handling nested `createdLocation` response from location-service API
- Updated `save` method to extract attributes from nested response structure
- Maintained backward compatibility for flat response structures

### Changed
- Updated test specs to match actual location-service API response structure

## [1.1.7] - 25/03/2024
fix bug unsupported 5xx error response exception

## [1.1.6] - 23/01/2024
fix bug related to memoize instance on class method

### Added

## [1.1.0] - 21/03/2023

### Added
- Location Class
- Search Class
- Collection of Location class
- Exception middleware
- Authentication middleware
- request id and user agent middleware

## [1.0.0] - 19/9/2022

### Added
- Initial realse
