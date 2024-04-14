/* 
  Homework#4

  Add your name here: Savannah Lescas

  You are free to create as many classes within the Hw4.cs file or across 
  multiple files as you need. However, ensure that the Hw4.cs file is the 
  only one that contains a Main method. This method should be within a 
  class named hw4. This specific setup is crucial because your instructor 
  will use the hw4 class to execute and evaluate your work.
*/

using System;
using System.IO;
using System.Collections.Generic;

// Alias
using sw = System.IO.StreamWriter;

// made Hw4 a struct
public struct Hw4
{
  // void delegate that works for all the methods using a ref List<Place>
  // as its parameter
  public delegate void VoidFunc(ref List<Place> allPlaces);
  static void runMethods()
  {
    string filename;
    List<Place> allPlaces = populatePlacesRecords(out filename);

    // all of the methods that need to be ran
    VoidFunc func = commonCities;
    func += getLatLon;
    func += cityStates;

    // does them with the List of all the records
    func(ref allPlaces);
  }
  public static void Main(string[] args)
  {
    // Capture the start time
    // Must be the first line of this method
    DateTime startTime = DateTime.Now; // Do not change
    // ============================
    // Do not add or change anything above, inside the 
    // Main method
    // ============================

    // call to the delegate
    runMethods();

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

  /*
  A method that populates a List of Place objects and returns it
   by getting the necessary information fom zipcodes.txt.
  */
  public static List<Place> populatePlacesRecords(out string filename)
  {
    // since the parameter is an out type we assign the parameter to a value
    // in the method
    filename = "zipcodes.txt";
    // reads all the lines from the zipcodes.txt file
    string[] lines = File.ReadAllLines(filename);
    // creates the List of Place objects to be returned
    List<Place> allPlaces = new List<Place>();

    // for loop that goes through the array of lines from zipcodes.txt
    for (int i = 1; i < lines.Length; i++)
    {
      string line = lines[i];
      // splits each line into parts by tabs
      string[] parts = line.Split('\t');
      // initializes a Place object
      Place record = new Place();
      // gets each necessary part of the line and puts it into the
      // Place object (record)
      if (parts.Length >= 8) // ensure there are at least 8 parts
      {
        record.setRecordNumber(int.Parse(parts[0]));
        record.setZipcode(int.Parse(parts[1]));
        record.setCity(parts[3]);
        record.setState(parts[4]);
        // some latitudes and longitudes don't have values so 
        // make them null if there are none
        if (string.IsNullOrWhiteSpace(parts[6]))
        {
          record.setLat(null);
        }
        else
        {
          record.setLat(double.Parse(parts[6]));
        }
        if (string.IsNullOrWhiteSpace(parts[7]))
        {
          record.setLon(null);
        }
        else
        {
          record.setLon(double.Parse(parts[7]));
        }

        // add the Place object to the list
        allPlaces.Add(record);
      }
    }

    // return the list
    return allPlaces;
  }

  /*
  A method that performs the common city names problem. It takes in a reference
  to the list of all the Place objects, reads the states.txt file, finds the city
  names of all the places that are common to each state from states.txt and writes
  them to CommonCityNames.txt.
  */
  public static void commonCities(ref List<Place> allPlaces)
  {
    // get the states to find common places of from states.txt
    string inputFile = "states.txt";
    string[] lines = File.ReadAllLines(inputFile);

    // a dictionary that has a string of the state name as the key
    // and a sorted set of all its cities as the value
    Dictionary<string, SortedSet<string>> stateCitiesDictionary
       = new Dictionary<string, SortedSet<string>>();

    // for every state in states.txt, add it to the dictionary with
    // an empty sorted set
    foreach (string state in lines)
    {
      stateCitiesDictionary[state] = new SortedSet<string>();
    }

    // for every Place object in the list, if record's state is a key 
    // in the dictionary, add its listed city to the sorted set
    foreach (Place record in allPlaces)
    {
      if (stateCitiesDictionary.ContainsKey(record.getState()))
      {
        stateCitiesDictionary[record.getState()].Add(record.getCity());
      }
    }

    // initializes a new sorted set with the values from the first state's
    // sorted set
    SortedSet<string> commonCities =
      new SortedSet<string>(stateCitiesDictionary[lines[0]]);

    // goes through every city name sorted set in the dictionary
    // and compares it withthe first state's city list.
    // the set will only contain cities that are in both sets
    // so in the end, no matter how many states there are, it
    // will only contain shared city names
    foreach (var cities in stateCitiesDictionary.Values)
    {
      // stack overflow showed me how to do this
      commonCities.IntersectWith(cities);
    }

    // write the common city names to the output file
    string outputFile = "CommonCityNames.txt";
    File.WriteAllText(outputFile, string.Empty);
    File.WriteAllLines(outputFile, commonCities);
  } // end commmonCities

  /*
  A method that perfoms the get latitude and longitude problem. It takes
  in the list of all Place objects, reads through zips.txt to get the 
  zipcodes to look for latitudes and longitudes for, goes through the 
  list of PLace objects and finds the first non-null values for the zipcode's
  latitude and longitudes and prints them to LatLon.txt.
  */
  public static void getLatLon(ref List<Place> allPlaces)
  {
    // get zip codes to find
    string inputFile = "zips.txt";
    string[] zipcodes = File.ReadAllLines(inputFile);

    // used a Stream Writer here to make it easier
    using (sw writer = new sw("LatLon.txt"))
    {

      // go through every zipcode from the zips.txt file
      foreach (string zip in zipcodes)
      {
        // made a SimplePlace object
        SimplePlace justZip = new Place();
        justZip.setZipcode(int.Parse(zip));
        // goes through every record in the list to find a matching
        // zipcode
        foreach (Place record in allPlaces)
        {
          // used an overrided operator to see if the zipcodes match
          if (justZip == record)
          {
            // if the latitude or longitude is null keep checking for non-null
            // values
            if (!record.getLat().HasValue || !record.getLon().HasValue)
            {
              continue;
            }
            else
            {
              // if they are not null write it to LatLon.txt separated by a space
              // and stop looking
              writer.WriteLine(record.getLat() + " " + record.getLon());
              break;
            }
          }
        }
      }
    }
  } // end getLatLon

  /*
  A method that perfroms the city states problem. Takes in the list
  of Place objects, reads the cities from cities.txt, creates a sorted
  set of all the states that have the certain city name, writes the
  list of sorted states to CityStates.txt.
  */
  public static void cityStates(ref List<Place> allPlaces)
  {
    // get zip codes to find
    string inputFile = "cities.txt";
    string[] cities = File.ReadAllLines(inputFile);

    // using a Stream Writer again to make it easier
    using (sw writer = new sw("CityStates.txt"))
    {

      // a loop that goes through each city name in the cities.txt file
      foreach (string city in cities)
      {
        // creates the sorted set to be populated with states that have
        // the city
        SortedSet<string> stateList = new SortedSet<string>();
        // made a new SimplePlace object so I can use the .Equals method
        SimplePlace justCity = new Place();
        justCity.setCity(city);
        // loop that gets every state that has the city and puts it into 
        // a sorted set
        foreach (Place record in allPlaces)
        {
          // using the overrided method
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

        writer.WriteLine();
      }

    }
  } // end cityStates

} // Hw4 Class

/*
A superclass that has only city and zipcode properties.
*/
public class SimplePlace
{
  public string city;
  public int zipcode;

  // overriding the Equals operator
  public override bool Equals(object obj)
  {
    if (obj is SimplePlace other)
    {
      return string.Equals(this.city, other.city, StringComparison.OrdinalIgnoreCase);
    }
    return false;
  }

  // this was apparently necessary to override the equals operator
  // ChatGPT
  public override int GetHashCode()
  {
    return city != null ? StringComparer.OrdinalIgnoreCase.GetHashCode(city) : 0;
  }

  // override the == operator
  public static bool operator ==(SimplePlace place1, SimplePlace place2)
  {
    return place1.getZipcode() == place2.getZipcode();
  }

  // needed this in order to override the == operator
  public static bool operator !=(SimplePlace place1, SimplePlace place2)
  {
    return !(place1.getZipcode() == place2.getZipcode());
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

/*
A subclass that inherits the SimplePlace superclass that also has
recordNumber, state, lat, and lon properties
*/
public class Place : SimplePlace
{
  public int recordNumber;
  public string state;
  // nullable latitude and longitude values
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