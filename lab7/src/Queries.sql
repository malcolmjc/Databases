-- R1

with DaysOccupiedLast180 as (
    select
    Room,
    SUM(DateDiff(Checkout,
    case
        when CheckIn >=  Current_Date - interval 180 day
        then CheckIn
        else Current_Date - interval 180 day
    end
    )) as DaysOccupied
    from lab7_reservations
    join lab7_rooms on Room = RoomCode
    where CheckOut > Current_Date - interval 180 day
    group by Room
),
MostRecentReservation as (
    select Room,
    MAX(CheckIn) as MostRecentCheckin,
    MAX(Checkout) as MostRecentCheckout
    from lab7_reservations
    group by Room
)
select
MostRecentReservation.Room,
ROUND(DaysOccupied / 180, 2),
DATE_ADD(MostRecentCheckout, interval 1 day) as FirstAvailable,
DATEDIFF(MostRecentCheckout,MostRecentCheckin) as LastStayLength,
MostRecentCheckout
from MostRecentReservation
join DaysOccupiedLast180 on DaysOccupiedLast180.Room = MostRecentReservation.Room
;

-- R2
-- Input:
-- CheckInDate: Date,
-- CheckOutDate: Date,
-- RoomCode: String (CHAR(3) || 'Any'),
-- BedType: String (VARCHAR(255) || 'Any')
-- NumChildren: Int
-- NumAdults: Int
show tables;
select distinct RoomId from
select distinct RoomId from Rooms
where @NumChildren + @NumAdults <= maxOccupancy
and (@BedType = bedType or @BedType = 'Any')
and (@RoomCode = RoomId or @RoomCode = 'Any')
;
-- RoomId,roomName,beds,bedType,maxOccupancy,basePrice,decor