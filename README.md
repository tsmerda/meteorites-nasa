# Meteorites NASA

## Overview

Meteorites NASA is an informative and engaging iOS application that provides details about meteorites that have fallen on Earth. Utilizing open data from NASA's API.

## Features

- **Detailed Listings:** Access comprehensive information about each meteorite, including size, location, and year of fall.
- **Map Integration:** Visualize the landing spots of meteorites on an interactive map.
- **NASA Open Data API:** Data is sourced directly from NASA's open API, ensuring accuracy and reliability.
- **Offline Access:** The app updates its data daily and is designed to work offline, fetching updates only when an internet connection is available.
- **User-Friendly Design:** Designed with simplicity and ease of use in mind.

## Data source

- Official website: [NASA Open Data Portal](https://data.nasa.gov)
- API Documentation: [NASA API Documentation](https://dev.socrata.com/foundry/data.nasa.gov/y77d-th95)
- JSON Data: [Meteorite Landings](https://data.nasa.gov/resource/y77d-th95.json)

## API limitations

For this project the number of NASA API requests is sufficient without specifying the X-App-Token. However, the request limit can be increased by registering on the NASA API portal and obtaining an app token. Implementing token management with a keychain wrapper is a secure method for handling API tokens. However, for this specific test application, such an approach was not required.
