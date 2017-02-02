package com.project.urlDetector;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Scanner;

public class UrlFileReader {

	public static void main(String args[]){

		File file = new File("D:\\MyProjects\\aks.txt");
		try {
			ArrayList<String> urlList = new ArrayList<>();
			/*Scanner scanner= new Scanner(file);
			while(scanner.hasNextLine()){
				System.out.println(scanner.nextLine());
				urlList.add(scanner.);
			}
				System.out.println(urlList);*/

			InputStream inp = new FileInputStream(file);
			BufferedReader reader = new BufferedReader(new InputStreamReader(inp));
			StringBuilder out = new StringBuilder();
			String line;
			System.out.println("***************************EXPECTED INPUT***************************");
			while ((line = reader.readLine().trim()) != null) {
				//   out.append(line);
				System.out.println(line);
				urlList.add(line);

			}
			// System.out.println(out.toString());  //Prints the string content read from input stream
			//System.out.println(urlList);
			reader.close();
			System.out.println("***************************EXPECTED OUTPUT***************************");
			for(String url:urlList){
				URL obj = new URL(url);
				URLConnection conn = obj.openConnection();
				HttpURLConnection connection = null;

				if(conn instanceof HttpURLConnection) {
					connection = (HttpURLConnection) conn;
				}else {
					System.out.println("Please enter an HTTP URL.");
					continue;
					//return;
				}
				BufferedReader in = new BufferedReader(
						new InputStreamReader(connection.getInputStream()));
				String urlString = "";
				String current;

				while((current = in.readLine()) != null) {
					urlString += current;
				}
				// System.out.println(urlString);
				String st= urlString.toString();
				//System.out.println(st);
				ArrayList<String> sports = new ArrayList<>();
				sports.add("Football");
				sports.add("Cricket");
				sports.add("Tennis");
				sports.add("Archery");
				sports.add("Hockey");
				sports.add("Basketball");
				int flag= 0;
				for(int i=0; i < sports.size(); i++){
					String sport = sports.get(i);
					if(st.toLowerCase().contains(sport.toLowerCase())){
					System.out.println(sport);
					flag=1;
					break;
					}
					
				}
				if(flag==0){
				System.out.println("NA");	
				}
			}
		}catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}


	}
}
