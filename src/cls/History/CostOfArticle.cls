Class History.CostOfArticle Extends %Persistent
{

Parameter DSTIME = "AUTO";

Relationship Member As Community.Member [ Cardinality = one, Inverse = Positions, OnDelete = cascade ];

Property Added As %Date;

Index Memder On Member;

Property Post As Community.Post;

Index Post On Post [ IdKey, Unique ];

Property Votes As %Integer;

Property Favorites As %Integer;

Property Comments As %Integer;

Property Views As %Integer;

Property Overall As %Integer;

Property LastUpdate As %Date;

Parameter VoteCost = 1000;

Parameter ViewCost = 3;

Parameter FavoriteCost = 1000;

Parameter CommentCost = 500;

ClassMethod GetCostOfArticle()
{
	set st = $$$OK
	
	set twoWeekBefore = $zdt($now(300)-14_","_$piece($now(300),",",2),3)
	
	set sql = "SELECT Nid AS Post, Author AS Member, Views, AvgVote AS Votes, SubsCount AS Favorites, isnull(cc.Com,0) AS Comments "
			 _"FROM Community.Post AS p "
			 _"LEFT OUTER JOIN (SELECT COUNT(1) AS Com, c.Post AS pid "
							  _"FROM Community.Comment AS c "
							  _"GROUP BY Post) AS cc ON p.nid = cc.pid "
			 _"WHERE p.PostType = 'Article' AND p.PublishedDate >= ?"
			
	set rs = ##class(%SQL.Statement).%ExecDirect(, sql, twoWeekBefore)
	
	while rs.%Next(){
		if (..%ExistsId(rs.Post)) {
			set st = ..Update(rs.Post, rs.Views, rs.Votes, rs.Favorites, rs.Comments)
		} else {
			set st = ..Insert(rs.Post, rs.Member, rs.Views, rs.Votes, rs.Favorites, rs.Comments)
		}
	}
	
	quit st
}

ClassMethod FillTable()
{
	set st = $$$OK
	
	do ..%KillExtent()
	
	set sql = "SELECT Nid AS Post, Author AS Member, Views, AvgVote AS Votes, SubsCount AS Favorites, isnull(cc.Com,0) AS Comments "
			 _"FROM Community.Post AS p "
			 _"LEFT OUTER JOIN (SELECT COUNT(1) AS Com, c.Post AS pid "
							  _"FROM Community.Comment AS c "
							  _"GROUP BY Post) AS cc ON p.nid = cc.pid "
			 _"WHERE p.PostType = 'Article'"
			
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	while rs.%Next(){
		set st = ..Insert(rs.Post, rs.Member, rs.Views, rs.Votes, rs.Favorites, rs.Comments)
	}
	
	quit st
}

ClassMethod Insert(Post, Member, Views, Votes, Favorites, Comments)
{
	set st = $$$OK
	set Added = +$now(300)
	set Overall = ..GetOverall(Views, Votes, Favorites, Comments)
	
	&sql(INSERT INTO History.CostOfArticle (Post, Member, Views, Votes, Favorites, Comments, Added, Overall, LastUpdate) 
				VALUES (:Post, :Member, :Views, :Votes, :Favorites, :Comments, :Added, :Overall, :Added))
	if (SQLCODE){
		set st = $$$ERROR($$$SQLError,SQLCODE,$get(%msg))
	}	
	
	quit st
}

ClassMethod Update(Post, Views, Votes, Favorites, Comments)
{
	set st = $$$OK
	set Update = +$now(300)
	set Overall = ..GetOverall(Views, Votes, Favorites, Comments)
	
	&sql(UPDATE History.CostOfArticle 
		SET Views = :Views, Votes = :Votes, Favorites = :Favorites, Comments = :Comments, Overall = :Overall, LastUpdate = :Update
		WHERE Post = :Post)
	if (SQLCODE){
		set st = $$$ERROR($$$SQLError,SQLCODE,$get(%msg))
	}
	
	quit st
}

ClassMethod GetOverall(Views, Votes, Favorites, Comments)
{
	set ViewsCost = ..#ViewCost * Views
	set FavoritesCost = ..#FavoriteCost * $SYSTEM.SQL.CEILING($double(Favorites) / 10)
	set CommentsCost = ..#CommentCost * $SYSTEM.SQL.CEILING($double(Comments) / 5)
	
	if (Votes < 0) {
		set VotesCost = 0
	} else {
		set VotesCost = ..#VoteCost * $SYSTEM.SQL.CEILING($double(Votes) / 5)
	}
	
	set Overall = 15000 + ViewsCost + FavoritesCost + VotesCost + CommentsCost
	
	quit Overall
}

Storage Default
{
<Data name="CostOfArticleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Member</Value>
</Value>
<Value name="3">
<Value>Votes</Value>
</Value>
<Value name="4">
<Value>Favorites</Value>
</Value>
<Value name="5">
<Value>Comments</Value>
</Value>
<Value name="6">
<Value>Added</Value>
</Value>
<Value name="7">
<Value>Post</Value>
</Value>
<Value name="8">
<Value>Views</Value>
</Value>
<Value name="9">
<Value>Overall</Value>
</Value>
<Value name="10">
<Value>LastUpdate</Value>
</Value>
</Data>
<DataLocation>^History.CostOfArticleD</DataLocation>
<DefaultData>CostOfArticleDefaultData</DefaultData>
<IdLocation>^History.CostOfArticleD</IdLocation>
<IndexLocation>^History.CostOfArticleI</IndexLocation>
<StreamLocation>^History.CostOfArticleS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

