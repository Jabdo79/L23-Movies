<%@ page import="movieio.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Lobster' rel='stylesheet' type='text/css'>
<style>
@import url(http://fonts.googleapis.com/css?family=Roboto:400,500,700,300,100);
h1 {
 font-family: 'Lobster', Georgia, Times, serif;
 font-size: 70px;
}
body {
  background-color: #3e94ec;
  font-family: "Roboto", helvetica, arial, sans-serif;
  font-size: 16px;
  font-weight: 400;
  text-rendering: optimizeLegibility;
}
a {
  color:#666B85;
  font-size:16px;
  font-weight:normal;
  text-shadow: 0 1px 1px rgba(256, 256, 256, 0.1);
}
tr:hover a {
  background:#4E5066;
  color:#FFFFFF;
}
div.table-title {
   display: block;
  margin: auto;
  max-width: 600px;
  padding:5px;
  width: 100%;
}
.table-title h3 {
   color: #fafafa;
   font-size: 30px;
   font-weight: 400;
   font-style:normal;
   font-family: "Roboto", helvetica, arial, sans-serif;
   text-shadow: -1px -1px 1px rgba(0, 0, 0, 0.1);
   text-transform:uppercase;
}
/*** Table Styles **/
.table-fill {
  background: white;
  border-radius:3px;
  border-collapse: collapse;
  height: 320px;
  margin: auto;
  max-width: 600px;
  padding:5px;
  width: 100%;
  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
  animation: float 5s infinite;
}
 
th {
  color:#D5DDE5;;
  background:#1b1e24;
  border-bottom:4px solid #9ea7af;
  border-right: 1px solid #343a45;
  font-size:23px;
  font-weight: 100;
  padding:24px;
  text-align:left;
  text-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
  vertical-align:middle;
}
th:first-child {
  border-top-left-radius:3px;
}
 
th:last-child {
  border-top-right-radius:3px;
  border-right:none;
}
  
tr {
  border-top: 1px solid #C1C3D1;
  border-bottom-: 1px solid #C1C3D1;
  color:#666B85;
  font-size:16px;
  font-weight:normal;
  text-shadow: 0 1px 1px rgba(256, 256, 256, 0.1);
}
 
tr:hover td {
  background:#4E5066;
  color:#FFFFFF;
  border-top: 1px solid #22262e;
  border-bottom: 1px solid #22262e;
}
 
tr:first-child {
  border-top:none;
}
tr:last-child {
  border-bottom:none;
}
 
tr:nth-child(odd) td {
  background:#EBEBEB;
}
 
tr:nth-child(odd):hover td {
  background:#4E5066;
}
tr:last-child td:first-child {
  border-bottom-left-radius:3px;
}
 
tr:last-child td:last-child {
  border-bottom-right-radius:3px;
}
 
td {
  background:#FFFFFF;
  padding:20px;
  text-align:left;
  vertical-align:middle;
  font-weight:300;
  font-size:18px;
  text-shadow: -1px -1px 1px rgba(0, 0, 0, 0.1);
  border-right: 1px solid #C1C3D1;
}
td:last-child {
  border-right: 0px;
}
th.text-left {
  text-align: left;
}
th.text-center {
  text-align: center;
}
th.text-right {
  text-align: right;
}
td.text-left {
  text-align: left;
}
td.text-center {
  text-align: center;
}
td.text-right {
  text-align: right;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Movie Database</title>
</head>
<body>
<h1 align="center">Movies</h1>
<div align="center">
<img alt="All Movies" src="images/posters/all.jpg">
<img alt="All Movies" src="images/posters/animated.jpg">
<img alt="All Movies" src="images/posters/comedy.jpg">
<img alt="All Movies" src="images/posters/drama.jpg">
<img alt="All Movies" src="images/posters/horror.jpg">
<img alt="All Movies" src="images/posters/musical.jpg">
<img alt="All Movies" src="images/posters/scifi.jpg">
</div>
	<%
		Connection con = null;
		Statement st = null;
		ResultSet rs = null;
		String url = "jdbc:mysql://localhost:3306/?useSSL=true";
		//DO NOT include this info in .java files pushed to GitHub in real projects
		String user = "java";
		String password = "java123";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(url, user, password);
			st = con.createStatement();
			String createDB = "CREATE DATABASE IF NOT EXISTS movies;";
			String use = "USE movies";
			String createTbl = "CREATE TABLE IF NOT EXISTS moviedb(ID int(255) NOT NULL AUTO_INCREMENT, Name varchar(50) NOT NULL, Category varchar(15) NOT NULL, PRIMARY KEY(ID));";
			st.execute(createDB);
			st.execute(use);
			st.execute(createTbl);
			rs = st.executeQuery("SELECT * FROM moviedb");
			if (!rs.next()) {
				PreparedStatement addMovie = con
						.prepareStatement("INSERT INTO moviedb (name, category) VALUES (?, ?)");
				for (int i = 1; i < 101; i++) {
					addMovie.setString(1, MovieIO.getMovie(i).getTitle());
					addMovie.setString(2, MovieIO.getMovie(i).getCategory());
					addMovie.execute();
				}
			}
		} catch (SQLException e) {
			out.println("DB Exception: " + e);
		}
	%>
	<form name="form" action="movies.jsp" method="post">
		<center><select name="categories">
			<option value="all">All Categories</option>
			<%
				try {
					String catQuery = "SELECT DISTINCT category FROM moviedb ORDER BY category ASC";
					rs = st.executeQuery(catQuery);
					while (rs.next()) {
						String cat = rs.getString(1);
						out.println("<option value=\"" + cat + "\">" + cat + "</option>");
					}
				} catch (SQLException e) {
					out.println("DB Exception: " + e);
				}
			%>
		</select> <input type="submit" value="View Category"></center>
	</form><br>

	<table class="table-fill" align="center">
		<tr>
			<th class="text-left"><a href="http://www.google.com/search?&sourceid=navclient&btnI=I&q=imdb%20"></a>Movie</th>
			<th class="text-left">Category</th>
		</tr>
		<tbody class="table-hover">
		<%
			String userCat = null;
			if (request.getParameter("categories") != null)
				userCat = request.getParameter("categories");
			try {
				String query = "";
				if (userCat == null || userCat.equals("all")) 
					rs = st.executeQuery("SELECT name, category FROM moviedb ORDER BY name");
				else {
					PreparedStatement chooseCat = con.prepareStatement("SELECT name, category FROM moviedb WHERE category = ? ORDER BY name");
					chooseCat.setString(1, userCat);
					rs = chooseCat.executeQuery();
				}
				while (rs.next()) {
					String name = rs.getString(1);
					String category = rs.getString(2);
					out.println("<tr><td class=\"text-left\"><a href=\"http://www.google.com/search?&sourceid=navclient&btnI=I&q=imdb "+name+"\">" + name + "</a></td><td class=\"text-left\">" + category + "</td></tr>");
				}
			} catch (SQLException e) {
				out.println("DB Exception: " + e);
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
					if (st != null) {
						st.close();
					}
					if (con != null) {
						con.close();
					}
				} catch (SQLException e) {
					out.println("DB Exception in finally: " + e);
				}
			}
		%>
		</tbody>
	</table>

</body>
</html>