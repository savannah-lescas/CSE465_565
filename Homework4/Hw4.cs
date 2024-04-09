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


    string[] lines = File.ReadAllLines("zipcodes.txt");
    List<Places> allPlaces = new List<Places>();
    for (int i = 1; i < lines.Length; i++)
    {
      string line = lines[i];
      string[] parts = line.Split('\t');
      if (parts.Length >= 8) // Ensure there are at least 8 parts
      {
        int recordNumber = int.Parse(parts[0]);
        int zipcode = int.Parse(parts[1]);
        string city = parts[3];
        string state = parts[4];
        double? lat = null;
        double? lon = null;
        if (double.TryParse(parts[6], out double parsedLat) && double.TryParse(parts[7], out double parsedLon))
        {
          lat = parsedLat;
          lon = parsedLon;
        }

        Places record = new Places(recordNumber, zipcode, city, state, lat, lon);
        allPlaces.Add(record);
      }
    }

    commonCities(allPlaces);
    getLatLon(allPlaces);


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
  }

  public static void commonCities(List<Places> allPlaces)
  {
    // get the states to find common places of from states.txt
    string inputFile = "states.txt";
    string[] lines = File.ReadAllLines(inputFile);

    Dictionary<string, SortedSet<string>> stateCitiesDictionary = new Dictionary<string, SortedSet<string>>();

    foreach (string state in lines)
    {
      stateCitiesDictionary[state] = new SortedSet<string>();
    }

    foreach (Places record in allPlaces)
    {
      if (stateCitiesDictionary.ContainsKey(record.state))
      {
        stateCitiesDictionary[record.state].Add(record.city);
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

  public static void getLatLon(List<Places> allPlaces)
  {
    // get zip codes to find
    string inputFile = "zips.txt";
    string[] zipcodes = File.ReadAllLines(inputFile);

    using (StreamWriter writer = new StreamWriter("LatLon.txt"))
    {

      foreach (string zip in zipcodes)
      {
        foreach (Places record in allPlaces)
        {
          if (int.Parse(zip) == record.zipcode)
          {
            // might need to implement a check if a zip code(first zipcode listed)
            // does not have a lot or lon
            writer.WriteLine(record.lat + " " + record.lon);
            break;
          }
        }
      }
    }
  } // end getLatLon
} // end main


public struct Places
{
  public int recordNumber, zipcode;
  public string city, state;
  public double? lat, lon;

  // constructor
  public Places(int recordNumber, int zipcode, string city, string state, double? lat, double? lon)
  {
    this.recordNumber = recordNumber;
    this.zipcode = zipcode;
    this.city = city;
    this.state = state;
    this.lat = lat;
    this.lon = lon;
  }

  // overriding ToString
  public override string ToString()
  {
    return $"Record Number: {recordNumber}, Zipcode: {zipcode}, City: {city}, State: {state}, Latitude: {lat}, Longitude: {lon}";
  }
}