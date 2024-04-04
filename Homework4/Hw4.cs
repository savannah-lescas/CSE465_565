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





        // TODO: your code goes here
        string[] lines = File.ReadAllLines("zipcodes.txt");
        List<Places> allPlaces = new List<Places>;
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
            float lat = float.Parse(parts[6]);
            float lon = float.Parse(parts[7]);

            Places record = new Places(recordNumber, zipcode, city, state, lat, lon);
            allPlaces.Add(record);
            // Process or use the variables as needed
            // For example, print them
            Console.WriteLine($"Record Number: {recordNumber}, Zipcode: {zipcode}, City: {city}, State: {state}, Latitude: {lat}, Longitude: {lon}");
          }
        }




        

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
}

public struct Places 
{
  public int recordNumber, zipcode;
  public string city, state;
  public double lat, lon;

  // Constructor
  public Places(int recordNumber, int zipcode, string city, string state, double lat, double lon)
  {
    this.recordNumber = recordNumber;
    this.zipcode = zipcode;
    this.city = city;
    this.state = state;
    this.lat = lat;
    this.lon = lon;
  }
}