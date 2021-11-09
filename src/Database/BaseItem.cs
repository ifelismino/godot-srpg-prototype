using Godot;
using System;

public abstract class BaseItem
{
	protected int id;
	protected String name;
	protected String description;
	protected bool consumable;
	protected int price;
	protected bool sellable;

	public int getId(){
		return id;
	}
	public void setId(int id){
		this.id = id;
	}
	public String getName(){
		return name;
	}
	public void setName(String name){
		this.name = name;
	}
	public String getDescription(){
		return description;
	}
	public void setDescription(String description){
		this.description = description;
	}
	public bool getConsumable(){
		return consumable;
	}
	public void setConsumable(bool consumable){
		this.consumable = consumable;
	}
	public int getPrice(){
		return price;
	}
	public void setPrice(int price){
		this.price = price;
	}
	public bool getSellable(){
		return sellable;
	}
	public void setSellable(int sellable){
		this.sellable = sellable;
	}
	
}
