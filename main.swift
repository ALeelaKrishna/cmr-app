import MongoKitten
import Foundation

//var url = 'mongodb://127.0.0.1:27017/admin'
let server: Server!

do {
	server = try Server("mongodb://durgadevi197:devi@ds151752.mlab.com:51752/food-court")
	let database = server["food-court"]
	let customer = database["customer"]
	let shop = database["shop"]
	print("Yes!!! you are connected to the remote database")
	
	var x = true

	while(x){

		print("\n\t\t\tSELECT AN OPTION\n1.Create a new user\n2.Purchase any item\n3.Recharge a card\n4.Delete a user\n5.Create a new shop\n")
		
		var opt = Int(readLine()!)
		//Unwrapping opt
		
		if let opt = opt{

			switch opt {
//create a new user		
				case 1:
						print("\n\t\tCREATE A USER")
						print("\nEnter userID:")
						var uID = String(readLine()!)

						print("\nEnter Amount:")
						var uAmount = Int(readLine()!)

						var userDocument: Document = [
						"uID": uID,
						"uAmount": uAmount,
						]

						//Insert a new customer

						try customer.insert(userDocument)
						print("\nYour account has been created!!\n")
//purchase an item				
				case 2:
						print("\n\t\tPURCHASE AN ITEM")
						print("\nEnter userID:")
						var uID = String(readLine()!)

						//Update the amount of user and check if the amount is greater than 0
						let result = try customer.find(["uID":uID])
						var q:Int = 0
						for x in result{
							var amount = x["uAmount"]
							q = Int(amount)!	
						}

						if q <= 0{
							print("\nSorry you are out of money.Please recharge it!\n")
						}
						else{
							print("\nEnter Amount:")
							//price ===> price of the item
							var price = Int(readLine()!)

							if (q-price!)<0{
								print("\nSorry your balance is not sufficient to purchase this item\n")
							}
							else{
								print("\nEnter shopID:")
								var shopID = String(readLine()!)	
								
								//check whether that shopID exists of not??

								try customer.update(["uID":uID], to: ["$set": ["uAmount": q-price!]])
								var cBalance = q-price!
								
								//Update the amount of shop
								
								let result = try shop.find(["shopID":shopID])
								var q:Int = 0
								for x in result{
									var amount2 = x["shopAmount"]
									q = Int(amount2)!	
								}
								let final_amount = q + price!
								try shop.update(["shopID":shopID],to:["$set": ["shopAmount": final_amount]])
								print("\nYour balance is \(cBalance) Rs.\n")	
							}

							
						}
//recharge a card				
				case 3:
						print("\n\t\tRECHARGE!!")
						print("\nEnter userID:")
						var uID = String(readLine()!)

						print("\nEnter Amount:")
						var amount = Int(readLine()!)

						//Update the amount of user
						let result = try customer.find(["uID":uID])
						var q:Int = 0
						for x in result{
							var amount = x["uAmount"]
							q = Int(amount)!	
						}
						let final_amount = q + amount!
						try customer.update(["uID":uID], to: ["$set": ["uAmount": final_amount]])
						print("\nYour account has been recharged with amount \(amount!) Rs.\nYour balance is \(final_amount) Rs.!!\n")
//delete a user
				case 4:
						print("\n\t\tDELETE")
						print("\nEnter userID:")
						var uID = String(readLine()!)
						let d: Query = "uID" == uID 
						try customer.remove(d)
						print("\nYour account has been deleted!!\n")
//create a new shop
				case 5:
						print("\n\t\tCREATE A SHOP")
						print("\nEnter shopID:")
						var shopID = String(readLine()!)

						var userDocument: Document = [
						"shopID": shopID,
						"shopAmount": 0,
						]

						//Insert a new customer

						try shop.insert(userDocument)

						//Display the list of all customers

						// let resultUsers = try customer.find()
						// for userDocument in resultUsers {
						//		print(userDocument,"\n")
						// }
//default case				
				default:print("\nYou have chosen nothing.\nPlease enter a valid input.\n")				
			}


		}

		print("Do you want to continue y/n")
		
		var option = readLine()
		if let option = option {}
		
		if(option == "n" || option == "N"){
			x = false 
		}
	}

} catch {
    // Unable to connect
	print("MongoDB is not available on the given host and port")
}

