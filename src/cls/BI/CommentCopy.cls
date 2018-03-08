/// 
Class BI.CommentCopy Extends %DeepSee.CubeDefinition [ DependsOn = (Community.Comment, Community.Post), ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="CommentCopy" displayName="CommentCopy" disabled="false" abstract="false" sourceClass="Community.Comment" countMeasureName="COMCOUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="AuthorName" disabled="false" sharesFrom="Post" hasAll="false" allCaption="All AuthorName" allDisplayName="AuthorName" type="data" hidden="false" showHierarchies="default">
  </dimension>
  <measure name="Comments" disabled="false" sourceProperty="Id" aggregate="COUNT" type="number" scale="0" hidden="false" searchable="false">
  </measure>
  <measure name="Comment points" disabled="false" sourceExpression="((%source.AvgVote)*(%source.VotesAmount))" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="CommentsInNonOwnPosts" disabled="false" sourceExpression="%cube.IsNonOwnPostComment(%source.Link)" aggregate="SUM" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="CommentRating" displayName="Comment Rating" disabled="false" sourceProperty="AvgVote" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <listing name="ComListing" disabled="false" listingType="table" fieldList="Author-&gt;Name,Link">
  </listing>
</cube>
}

ClassMethod GetMembersAmount()
{
	set result = 0
	set sql = "Select Count(Id) As MembersAmount From Community.Member"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	if rs.%Next() {set result = rs.MembersAmount}
	Quit result
}

ClassMethod IsNonOwnPostComment(commentLink)
{
	set result = 0
	set sql = "Select Author As CommentAuthor, Post->Author As PostAuthor From Community.Comment Where Link = ?"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,commentLink)
	if rs.%Next() {set:rs.CommentAuthor'=rs.PostAuthor result = 1}
	Quit result
}

ClassMethod GetGroupName(postId, prop As %String) As %String
{
	set result = ""
	set sql = "Select GroupClass->"_prop_" As GroupProp From Community.GroupPost Where Post = ?"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql, postId)
	while rs.%Next(){
		if result = "" {set result = rs.GroupProp}
		else{set result = result_","_rs.GroupProp}
	}
	Quit result
}

Parameter DOMAIN;

}

