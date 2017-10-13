Include Community

Class Community.Member Extends %Persistent
{

Parameter DSTIME = "AUTO";

Property Uid As %Integer [ Required ];

Index IDKEY On Uid [ IdKey, Unique ];

Property Added As %Date;

Property Name As %String(MAXLEN = 255) [ SqlComputeCode = {set {*} = {FirstName} _ " " _ {LastName}}, SqlComputed, SqlComputeOnChange = (LastName, FirstName) ];

Property FirstName As %String(MAXLEN = 255);

Property LastName As %String(MAXLEN = 255);

Property Company As %String(MAXLEN = 255);

Property Position As %String(MAXLEN = 255);

Property Created As %TimeStamp;

Property Link As %String(MAXLEN = 150) [ SqlComputeCode = {set {*} = $$$Server _ "user/" _ {Uid}}, SqlComputed, SqlComputeOnChange = %%INSERT ];

Index Link On Link [ Unique ];

Property SubSuspended As %Numeric;

Property Hash As %String;

Relationship Posts As Community.Post [ Cardinality = many, Inverse = Author ];

Relationship Comments As Community.Comment [ Cardinality = many, Inverse = Author ];

Relationship Votes As Community.Vote [ Cardinality = many, Inverse = Author ];

ClassMethod Upsert(Uid, FirstName, LastName, Company, Position, Created, SubSuspended) As %Status
{
	Set Hash = ##class(Community.Utils.Hash).Hash(Uid, FirstName, LastName, Company, Position, Created) 
 	Return:(Hash=..HashGetStored(Uid)) $$$OK
	
	If ..%ExistsId(Uid) {
		Set Member = ..%OpenId(Uid)
	} Else {
		Set Member = ..%New()
		Set Member.Uid = Uid
	}

	Set Member.Hash = Hash
	Set Member.FirstName = FirstName
	Set Member.LastName = LastName
	Set Member.Company = Company
	Set Member.Position = Position
	
	Set Member.Created = Created
	Set Member.SubSuspended = SubSuspended
	
	Set st = Member.%Save()
	
	Return st
}

Storage Default
{
<Data name="MemberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Added</Value>
</Value>
<Value name="3">
<Value>ISCMember</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>FirstName</Value>
</Value>
<Value name="6">
<Value>LastName</Value>
</Value>
<Value name="7">
<Value>Email</Value>
</Value>
<Value name="8">
<Value>Company</Value>
</Value>
<Value name="9">
<Value>Position</Value>
</Value>
<Value name="10">
<Value>Created</Value>
</Value>
<Value name="11">
<Value>Link</Value>
</Value>
<Value name="12">
<Value>OfficeLocation</Value>
</Value>
<Value name="13">
<Value>Branch</Value>
</Value>
<Value name="14">
<Value>Department</Value>
</Value>
<Value name="15">
<Value>SubSuspended</Value>
</Value>
<Value name="16">
<Value>Hash</Value>
</Value>
</Data>
<DataLocation>^Community.MemberD</DataLocation>
<DefaultData>MemberDefaultData</DefaultData>
<IdLocation>^Community.MemberD</IdLocation>
<IndexLocation>^Community.MemberI</IndexLocation>
<StreamLocation>^Community.MemberS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

