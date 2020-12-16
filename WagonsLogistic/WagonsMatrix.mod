 using CP;
  execute PARAMS{cp.param.TimeLimit = 60;}
  
 {int} wagons = ...;
{int} shipmentPoint = ... ;

int shippmentStartDate[shipmentPoint] = ...; // дата отправления груженого рейса
int shippmentDuration[shipmentPoint] = ...;//среднее время в пути по направлению груженого рейса

int emptyTrainDuratopm[shipmentPoint][shipmentPoint] = ...;

dvar interval Shippment[sp in shipmentPoint] optional size shippmentDuration[sp] ;


dvar sequence Wagon in Shippment types [1,2];

subject to
{
		
}