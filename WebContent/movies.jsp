<%@ page import="movieio.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
table {
	width: 100%;
}

table, th, td {
	border: 1px solid black;
	border-collapse: collapse;
}

th, td {
	padding: 5px;
	text-align: left;
}

tr:nth-child(even) {
	background-color: #eee;
}

tr:nth-child(odd) {
	background-color: #fff;
}

th {
	background-color: black;
	color: white;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Movie Database</title>
</head>
<body>

	<table>
		<tr>
			<th>Movie</th>
			<th>Category</th>
		</tr>

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
			    String createTbl = "CREATE TABLE IF NOT EXISTS moviedb(ID int(255), Name varchar(50), Category varchar(15));";
			    st.execute(createDB);
			    st.execute(use);
			    st.execute(createTbl);
			    
			    rs = st.executeQuery("SELECT * FROM moviedb");
			    if(!rs.next()){
			    	String insert = "INSERT INTO moviedb (name, category) VALUES (?, ?)";
				    PreparedStatement addMovie = con.prepareStatement(insert);
				    for(int i = 1; i < 101; i++){
				    	addMovie.setString(1, MovieIO.getMovie(i).getTitle());
				    	addMovie.setString(2, MovieIO.getMovie(i).getCategory());
				    	addMovie.execute();
				    	
				    }	
			    }		    			    
			} catch (SQLException e) {
				out.println("DB Exception: " + e);
			}

			String userCat = null;
			if (request.getParameter("categories") != null)
				userCat = request.getParameter("categories");

			String query = "";
			if (userCat == null || userCat.equals("all"))
				query = "SELECT name, category FROM moviedb";
			else
				query = "SELECT name, category FROM moviedb WHERE category ='" + userCat + "'";

			try {
				rs = st.executeQuery(query);

				while (rs.next()) {
					String name = rs.getString(1);
					String category = rs.getString(2);
					out.println("<tr><td>" + name + "</td><td>" + category + "</td></tr>");
				}
			} catch (SQLException e) {
				out.println("DB Exception: " + e);

			}
		%>
	</table>
	<form name="form" action="movies.jsp" method="post">
		<select name="categories">
			<option value="all">All Categories</option>
			<%
				try {
					String catQuery = "SELECT DISTINCT category FROM moviedb";
					rs = st.executeQuery(catQuery);

					while (rs.next()) {
						String cat = rs.getString(1);
						out.println("<option value=\"" + cat + "\">" + cat + "</option>");
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
		</select> <input type="submit" value="View Category">
	</form>

</body>
</html>