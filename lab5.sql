 --Bài 1
 create procedure sp_hello
	@Ten nvarchar(30)
as
begin
	print'Hello' + @Ten;
end;

exec sp_hello N'Trung';

--------------------

create proc sp_sum
	@s1 int, @s2 int
as 
begin
	declare @tg int;
	set @tg = @s1 + @s2;
	print N'Tổng là: ' + cast(@tg as varchar);
end;

exec sp_sum 4,7;

--------------------

create proc sp_sumEven2
	@n int
as
begin 
	declare @sum int, @i int;
	set @sum = 0;
	set @i = 1;
	while @i <= @n
	begin
		if @i % 2 = 0
		begin 
			set @sum = @sum + @i;
		end;
		set @i = @i + 1;
	end;
	print N'Tổng các số chẵn: ' + cast(@sum as varchar);
end;

exec sp_sumEven2 10

--------------------

create proc sp_uocsochung
	@a int, @b int
as
begin
	declare @temp int;
	if @a > @b 
	begin 
		select @temp = @a, @a = @b, @b = @temp;
	end
	while @b % @a != 0
	begin 
		select @temp = @a, @a = @b % @a, @b = @temp;
	end;
	print N'Ước số chung lớn nhất là : ' + cast(@a as varchar);
end;

exec sp_uocsochung 20, 6;

--Bài 2

create proc sp_timNVtheoMa
	@MaNV nvarchar(9)
as
begin 
	select*from NHANVIEN where MANV = @MaNV;
end;

exec sp_timNVtheoMa '004';

--------------------

create proc sp_tongNVthamgiaDA
	@MaDa int
as
begin
	select count(MA_NVIEN) as 'Số Lượng' from PHANCONG where MADA = @MaDa;
end;

exec sp_tongNVthamgiaDA 4;

--------------------

create proc sp_thongkeNVDA
	@MaDa int, @DDiem_DA nvarchar(20)
as
begin
	select count(b.ma_nvien) as 'Số Lượng'
		from DEAN a inner join PHANCONG b on a.MADA = b.MADA
		where a.MADA = @MaDa and a.DDIEM_DA = @DDiem_DA;
end;

exec sp_thongkeNVDA 10, N'Hà nội'

--------------------

create proc sp_timNVtheoTP
	@TrPHG nvarchar(9)
as
begin
	select b.*from PHONGBAN a inner join NHANVIEN b on a.MAPHG = b.PHG
		where a.TRPHG = @TrPHG and
			not exists(select*from THANNHAN where MANV = b.MANV)
end;

exec sp_timNVtheoTP '005'

--------------------

create proc sp_kiemtraNVthuocphong
	@MaNV nvarchar(9), @MaPB int
as
begin 
	declare @Dem int;
	select @Dem = count(manv) from NHANVIEN where MANV = @MaNV and PHG = @MaPB;
	return @Dem;
end;

declare @result int;
exec @result = sp_kiemtraNVthuocphong '005', 5;
select @result;

--Bài 3

create proc sp_themphongbanmoi
	@TENPHG nvarchar(15),
	@MAPHG int,
	@TRPHG nvarchar(9),
	@NG_NHANCHUC date
as
begin 
	if exists(select*from PHONGBAN where MAPHG = @MAPHG)
	begin
		print N' Mã phòng đã tồn tại';
		return;
	end
	insert into PHONGBAN(TENPHG,MAPHG,TRPHG,NG_NHANCHUC) values(@TENPHG,@MAPHG,@TRPHG,@NG_NHANCHUC);
end;

exec sp_themphongbanmoi 'CNTT',15, '005', '10-12-2020';

--------------------

create proc sp_capnhatphongban
	@TENPHGCU nvarchar(15),
	@TENPHG nvarchar(15),
	@MAPHG int,
	@TRPHG nvarchar(9),
	@NG_NHANCHUC date
as
begin
	update PHONGBAN
	set TENPHG = @TENPHG,
		MAPHG = @MAPHG,
		TRPHG = @TRPHG,
		NG_NHANCHUC = @NG_NHANCHUC
	where TENPHG = @TENPHGCU;
end;

exec sp_capnhatphongban 'CNTT', 'IT', 10, '005', '1-1-2020';

--------------------

create proc sp_themNV
	@HONV nvarchar(15),
	@TENLOT nvarchar(15),
	@TENNV nvarchar(15),
	@MANV nvarchar(9),
	@NGSINH datetime,
	@DCHI nvarchar(30),
	@PHAI nvarchar(3),
	@LUONG float,
	@PHG int
as
begin
	if not exists(select*from PHONGBAN where TENPHG = 'IT')
	begin
		print N'Nhân viên phải trực thuộc phòng IT';
		return;
	end;
	declare @MA_NQL nvarchar(9);
	if @LUONG > 25000
		set @MA_NQL = '005';
	else
		set @MA_NQL = '009';
	declare @age int;
	select @age = DATEDIFF(year,@NGSINH,getdate()) + 1;
	if @PHAI = 'Nam' and (@age < 18 or @age >60)
	begin
		print N'Nam phải có độ tuổi từ 18-65';
		return;
	end;
	else if @PHAI = 'Nữ' and (@age < 18 or @age >60)
	begin
		print N'Nữ phải có độ tuổi từ 18-60';
		return;
	end;
	INSERT INTO NHANVIEN(HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
		VALUES(@HONV,@TENLOT,@TENNV,@MANV,@NGSINH,@DCHI,@PHAI,@LUONG,@MA_NQL,@PHG)
end;

exec sp_themNV N'Nguyễn',N'Hoàng',N'Tuấn','022','12-5-1977',N'Hà Nội','Nam',30000,6;
