Class Community.iKnow.Similar Extends %Persistent [ DependsOn = Community.Post ]
{

Property Nid As %Integer [ Required ];

Index IDKEY On Nid [ IdKey, Unique ];

Property Similar As list Of %Integer(SQLPROJECTION = "table/column", STORAGEDEFAULT = "array");

Property Updated As %TimeStamp;

Parameter Count As %Integer = 5;

ClassMethod ToJSON(Nid As %Integer, ReturnURL As %Boolean, count As %Integer) As %DynamicArray
{
	#dim arr As %DynamicArray = []
	set obj = ..%OpenId(Nid)

	for i=1:1:obj.Similar.Count()
	{
		if (ReturnURL = $$$YES){
			do arr.%Push("https://community.intersystems.com/node/" _ obj.Similar.GetAt(i))
		}else{
			do arr.%Push(obj.Similar.GetAt(i))
		}
		quit:i=count
	}
	quit arr.%ToJSON()
}

ClassMethod AddAll() As %Status
{
	w "Start analize similar posts...",!
	set sc = $$$OK
	&sql(DECLARE C1 CURSOR FOR
	SELECT id INTO :id
	FROM Community.Post)

	&sql(OPEN C1)
	&sql(FETCH C1)

	while (SQLCODE = 0) 
	{
		set sc = ..AddOne(id)
		&sql(FETCH C1)
	}
	&sql(CLOSE C1)
	w "Done!",!
	return sc
}

/// do ##class(Community.iKnow.Similar).AddOne()
ClassMethod AddOne(Nid As %Integer) As %Status
{
	set sc = ##class(Community.iKnow.SimilarTitles).GetSimilarTitlesByPostID(Nid, ..#Count, .titles)
	set sc = ##class(Community.iKnow.SimilarPosts).GetSimilarTextByPostID(Nid, ..#Count, .texts)
	
	
	set key = $ORDER(titles(""),1,value)
	while(key'="")
	{	
		set final(key) = value * 2
		set key=$ORDER(titles(key),1,value)
	}
	
	set key = $ORDER(texts(""),1,value)
	while(key'="")
	{	
		if ($DATA(final(key))>0){
			set final(key) = final(key) + value
		}else{
			set final(key) = value
		}
		set key=$ORDER(texts(key),1,value)
	}
	
	set rs = ..SimilarTagsCountFunc(Nid, ##class(Community.Post).TagsGetStored(Nid))
	
	while (rs.%Next())
	{
		set key = rs.ID
		set value = rs.count/5
		
		if ($DATA(final(key))>0){
			set final(key) = final(key) + value
		}else{
			set final(key) = value
		}
	}
	
	set key = $ORDER(final(""),1,value)
	set similar = ""
	while(key'="")
	{	
		if ($DATA(similar(value))>0){
			if ($ListValid(similar(value))){
				set similar(value) = similar(value)_$LB(key)
			}else{
				set similar(value) = $LB(similar(value),key)
			}
		}else{
			set similar(value) = key
		}
		set key=$ORDER(final(key),1,value)
	}
	
	set obj = ..%New()
	set obj.Nid = Nid
	set obj.Updated = $ZDT($H, 3)
	
	set count = 0
	
	set key = $ORDER(similar(""),-1,value)
	while (key'="")
	{
		if ($ListValid(value))
		{
			for i=1:1:$ListLength(value)
			{
				set element = $ListGet(value,i)
				do obj.Similar.Insert(element)
				set count = count + 1
				quit:count>=..#Count
			}

		}else{
			do obj.Similar.Insert(value)
			set count = count + 1
		}
		quit:count>=..#Count
		set key=$ORDER(similar(key),-1,value)
	}
	return obj.%Save()
}

Query SimilarTagsCount(Nid As %Integer, tags As %String) As %SQLQuery
{
SELECT top 5 ID, Community_iKnow.Utils_SimPieceCount(:tags, tags) as "count" 
FROM Community.Post
WHERE ID <> :Nid 
ORDER BY 2 desc
}

ClassMethod Start() As %Status
{
	set sc = $$$OK
	set sc = ##class(Community.iKnow.Similar).%KillExtent()
	set sc = ##class(Community.iKnow.SimilarPosts).Update()
	set sc = ##class(Community.iKnow.SimilarTitles).Update()
	set sc = ..AddAll()
	quit sc
}

Storage Default
{
<Data name="Similar">
<Attribute>Similar</Attribute>
<Structure>subnode</Structure>
<Subscript>"Similar"</Subscript>
</Data>
<Data name="SimilarDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Updated</Value>
</Value>
</Data>
<DataLocation>^Community.iKnow.SimilarD</DataLocation>
<DefaultData>SimilarDefaultData</DefaultData>
<IdLocation>^Community.iKnow.SimilarD</IdLocation>
<IndexLocation>^Community.iKnow.SimilarI</IndexLocation>
<StreamLocation>^Community.iKnow.SimilarS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

