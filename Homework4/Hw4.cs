/* 
  Homework#4

  Add your name here: Savannah Lescas

  You are free to create as many classes within the Hw4.cs file or across 
  multiple files as you need. However, ensure that the Hw4.cs file is the 
  only one that contains a Main method. This method should be within a 
  class named hw4. This specific setup is crucial because your instructor 
  will use the hw4 class to execute and evaluate your work.
  */
// BONUS POINT:
// => Used Pointers from lines 10 to 15 <=
// => Used Pointers from lines 40 to 63 <=


using System;
using System.IO;
using System.Collections.Generic;

// Alias
using sw = System.IO.StreamWriter;

public class Hw4
{
  public static void Main(string[] args)
  {
    // Capture the start time
    // Must be the first line of this method
    DateTime startTime = DateTime.Now; // Do not change
    // ============================
    // Do not add or change anything above, inside the 
    // Main method
    // ============================

    string filename;
    // using a different type of parameter variable (out)
    List<Place> allPlaces = populatePlacesRecords(out filename);

    // using a different type of parameter variable (ref)
    commonCities(ref allPlaces);
    getLatLon(ref allPlaces);
    cityStates(ref allPlaces);


    // ============================
    // Do not add or change anything below, inside the 
    // Main method
    // ============================

    // Capture the end time
    DateTime endTime = DateTime.Now;  // Do not change

    // Calculate the elapsed time
    TimeSpan elapsedTime = endTime - startTime; // Do not change

    // Display the elapsed time in milliseconds
    Console.WriteLine($"Elapsed Time: {elapsedTime.TotalMilliseconds} ms");
  } // end main

  public static List<Place> populatePlacesRecords(out string filename)
  {
    filename = "zipcodes.txt";
    string[] lines = File.ReadAllLines(filename);
    List<Place> allPlaces = new List<Place>();
    for (int i = 1; i < lines.Length; i++)
    {
      string line = lines[i];
      string[] parts = line.Split('\t');
      Place record = new Place();
      if (parts.Length >= 8) // Ensure there are at least 8 parts
      {
        record.setRecordNumber(int.Parse(parts[0]));
        record.setZipcode(int.Parse(parts[1]));
        record.setCity(parts[3]);
        record.setState(parts[4]);
        record.setLat(null);
        record.setLon(null);
        // chatgpt helped come up with this tester to see if the lat/lon
        // is able to be parsed to a double
        if (double.TryParse(parts[6], out double parsedLat) && double.TryParse(parts[7], out double parsedLon))
        {
          record.setLat(parsedLat);
          record.setLon(parsedLon);
        }

        allPlaces.Add(record);
      }
    }
    return allPlaces;
  }

  public static void commonCities(ref List<Place> allPlaces)
  {
    // get the states to find common places of from states.txt
    string inputFile = "states.txt";
    string[] lines = File.ReadAllLines(inputFile);

    Dictionary<string, SortedSet<string>> stateCitiesDictionary = new Dictionary<string, SortedSet<string>>();

    foreach (string state in lines)
    {
      stateCitiesDictionary[state] = new SortedSet<string>();
    }

    foreach (Place record in allPlaces)
    {
      if (stateCitiesDictionary.ContainsKey(record.getState()))
      {
        stateCitiesDictionary[record.getState()].Add(record.getCity());
      }
    }

    SortedSet<string> commonCities = new SortedSet<string>(stateCitiesDictionary[lines[0]]);
    foreach (var cities in stateCitiesDictionary.Values)
    {
      commonCities.IntersectWith(cities);
    }

    // write the common city names to the output file
    string outputFile = "CommonCityNames.txt";
    File.WriteAllText(outputFile, string.Empty);
    File.WriteAllLines(outputFile, commonCities);
  } // end commmonCities

  public static void getLatLon(ref List<Place> allPlaces)
  {
    // get zip codes to find
    string inputFile = "zips.txt";
    string[] zipcodes = File.ReadAllLines(inputFile);

    using (sw writer = new sw("LatLon.txt"))
    {

      foreach (string zip in zipcodes)
      {
        // made a SimplePlace object
        SimplePlace justZip = new Place();
        justZip.setZipcode(int.Parse(zip));
        foreach (Place record in allPlaces)
        {
          if (justZip == record)
          {
            // might need to implement a check if a zip code(first zipcode listed)
            // does not have a lot or lon
            writer.WriteLine(record.getLat() + " " + record.getLon());
            break;
          }
        }
      }
    }
  } // end getLatLon

  public static void cityStates(ref List<Place> allPlaces)
  {
    // get zip codes to find
    string inputFile = "cities.txt";
    string[] cities = File.ReadAllLines(inputFile);

    SortedSet<string> stateList = new SortedSet<string>();

    using (sw writer = new sw("CityStates.txt"))
    {

      // a loop that goes through each city name in the cities.txt file
      foreach (string city in cities)
      {
        // made a new SimplePlace object so I can use the .Equals method
        SimplePlace justCity = new Place();
        justCity.setCity(city);
        // loop that gets every state that has the city and puts it into 
        // a sorted set
        foreach (Place record in allPlaces)
        {
          if (justCity.Equals(record))
          {
            stateList.Add(record.getState());
          }
        }

        // write to the file
        foreach (string state in stateList)
        {
          writer.Write(state + " ");
        }

        // clear the set before going onto the next city in the list
        writer.WriteLine();
        stateList.Clear();
      }

    }
  } // end cityStates

} // Hw4 Class

public class SimplePlace
{
  public string city;
  public int zipcode;

  public override bool Equals(object obj)
  {
    if (obj is SimplePlace other)
    {
      return string.Equals(this.city, other.city, StringComparison.OrdinalIgnoreCase);
    }
    return false;
  }

  // override an operator
  public static bool operator ==(SimplePlace place1, SimplePlace place2)
  {
    return place1.getZipcode() == place2.getZipcode();
  }

  public static bool operator !=(SimplePlace place1, SimplePlace place2)
  {
    return !(place1.getZipcode() == place2.getZipcode());
  }

  public override int GetHashCode()
  {
    return city != null ? StringComparer.OrdinalIgnoreCase.GetHashCode(city) : 0;
  }
  // geter and setter methods for zipcode
  public int getZipcode()
  {
    return zipcode;
  }

  public void setZipcode(int value)
  {
    zipcode = value;
  }

  // getter and setter methods for city
  public string getCity()
  {
    return city;
  }

  public void setCity(string value)
  {
    city = value;
  }
}

public class Place : SimplePlace
{
  public int recordNumber;
  public string state;
  public double? lat, lon;

  // constructor
  public Place(int recordNumber = 0, int zipcode = 0, string city = "",
    string state = "", double? lat = null, double? lon = null)
  {
    this.recordNumber = recordNumber;
    this.zipcode = zipcode;
    this.city = city;
    this.state = state;
    this.lat = lat;
    this.lon = lon;
  }

  // getter and setter methods for recordNumber
  public int getRecordNumber()
  {
    return recordNumber;
  }

  public void setRecordNumber(int value)
  {
    recordNumber = value;
  }

  // getter and setter methods for state
  public string getState()
  {
    return state;
  }

  public void setState(string value)
  {
    state = value;
  }

  // getter and setter methods for lat
  public double? getLat()
  {
    return lat;
  }

  public void setLat(double? value)
  {
    lat = value;
  }

  // getter and setter methods for lon
  public double? getLon()
  {
    return lon;
  }

  public void setLon(double? value)
  {
    lon = value;
  }
}