Class History.ChampionshipPositions Extends %Persistent [ DependsOn = (Community.Member, Community.Group) ]
{

Parameter DSTIME = "AUTO";

Relationship Member As Community.Member [ Cardinality = one, Inverse = Positions, OnDelete = cascade ];

Index Member On Member;

Relationship GroupClass As Community.Group [ Cardinality = one, Inverse = Positions, OnDelete = cascade ];

Index GroupClass On GroupClass;

Property CommentVotes As %Integer;

Property CorrectAnswers As %Integer;

Property Comments As %Integer;

Property PostVotes As %Integer;

Property PostSubscriptions As %Integer;

Property Posts As %Integer;

Property Views As %Integer;

Property CommentsAmount As %Integer;

Property Overall As %Integer [ Calculated, SqlComputeCode = { set {*} = {CommentVotes}+{Comments}+{PostVotes}+{Posts}+{CommentsAmount}+{Views}+{PostSubscriptions}+{CorrectAnswers}}, SqlComputed ];

Property Added As %Date;

Index MemberAndAddedAndGroup On (Member, Added, GroupClass);

Storage Default
{
<Data name="ChampionshipPositionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Member</Value>
</Value>
<Value name="3">
<Value>Overall</Value>
</Value>
<Value name="4">
<Value>Position</Value>
</Value>
<Value name="5">
<Value>Created</Value>
</Value>
<Value name="6">
<Value>Added</Value>
</Value>
<Value name="7">
<Value>Groups</Value>
</Value>
<Value name="8">
<Value>GroupClass</Value>
</Value>
<Value name="9">
<Value>CommentVotes</Value>
</Value>
<Value name="10">
<Value>Comments</Value>
</Value>
<Value name="11">
<Value>PostsVotes</Value>
</Value>
<Value name="12">
<Value>Posts</Value>
</Value>
<Value name="13">
<Value>CommentsAmount</Value>
</Value>
<Value name="14">
<Value>PostVotes</Value>
</Value>
<Value name="15">
<Value>Views</Value>
</Value>
<Value name="16">
<Value>CorrectAnswers</Value>
</Value>
<Value name="17">
<Value>PostSubscriptions</Value>
</Value>
</Data>
<DataLocation>^History.ChampionshipPositionsD</DataLocation>
<DefaultData>ChampionshipPositionsDefaultData</DefaultData>
<IdLocation>^History.ChampionshipPositionsD</IdLocation>
<IndexLocation>^History.ChampionshipPositionsI</IndexLocation>
<StreamLocation>^History.ChampionshipPositionsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

