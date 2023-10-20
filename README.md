# FlightCalculator

# Technical task

**Create a custom LWC/Visualforce page in Salesforce that allows the user to create a Flight between two airports, calculate the flight distance and save the flight in the database. The application must fulfill the following requirements:**

  **Provide a frontend form to fill in the details:**

      -Arrival airport: will be retrieved from the database filtering by IATA code. 
      -Departure airport: will be retrieved from the database filtering by IATA code

  **Save flight:**
  
      The flight is saved to the database, storing the following values:

        -Departure airport 
        -Arrival airport 
        -Flight distance in kilometers 
      
      After saving the flight, display in the frontend the resulting flight information (departure airport, arrival airport, and flight distance).

  **Other useful information**

    The Airports are identified by a 3-letter code called IATA (i.e. Barcelona Airport code is BCN).

    The Airport must also store longitude and latitude.

      -Latitude: the valid range for latitude values is from +90 to -90 degrees. 
      -Longitude: the valid range for longitude values is from +180 to -180 degrees.

    The flight distance can be computed using the Haversine formula described in the provided Apex method.
