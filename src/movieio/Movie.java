package movieio;


public class Movie implements Comparable<Movie> {
	private String title = "", category = "";
	private int categoryNum = 0;
	
	public Movie(String title, String category){
		this.title = title;
		this.category = category;
		
		switch(category){
		case "animated":
			categoryNum = 1;
			break;
		case "drama":
			categoryNum = 2;
			break;
		case "horror":
			categoryNum = 3;
			break;
		case "scifi":
			categoryNum = 4;
			break;
		}
		
	}
	
	public String getTitle(){
		return title;
	}
	
	public String getCategory(){
		return category;
	}
	
	public int getCategoryNum(){
		return categoryNum;
	}

	public int compareTo(Movie other) {
		return getTitle().compareToIgnoreCase(other.getTitle());
	}
	
}
