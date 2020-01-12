db.getCollection("lodging").find({});
// 1. Print only the names, surnames and ages of all hosts.

db.getCollection("lodging").find(
    { 
        "host" : {
            "$exists" : true
        }
    }, 
    {
        "host.name" : 1.0, 
        "host.surname" : 1.0, 
        "host.age" : 1.0
    }
);

db.lodging.aggregate( [ { $project : { "host.name" : 1 , "host.surname" : 1, "host.age": 1 } } ] );

// 6. Print a list of all accommodations from the state of Ohio, where the host speaks English or the accommodation has an average score of over 7.5.

db.getCollection("lodging").aggregate([
{
  $group:
  {
      _id: "$_id",
      l
  }  
},
{
    $match: {
        $and: [ 
        {
            $or : [ 
                    {"host.languages" : "english"},
                    
                   ]
        },
        {
        "lodging.address.state" : "Ohio",
        }
        ]
    }
},
{
    $project: {
        "lodging.address.state" : 1,
        "host.languages": 1
    }
}
]);



