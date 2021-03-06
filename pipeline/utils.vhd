--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes,
--		 constants, and functions
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package utils is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
	type reg_wb_init_control is
		record
			reg_wb_signal: std_logic;
			reg_wb_chooser: std_logic_vector(1 downto 0);
			reg_wb_data_chooser: std_logic;
		end record;

	constant zero_reg_wb_init_control : reg_wb_init_control :=
		(
			reg_wb_signal => '0',
			reg_wb_chooser => "00",
			reg_wb_data_chooser => '0'
		);

	type reg_wb_control is
		record
			reg_wb_signal: std_logic;
			reg_wb_regs: std_logic_vector(2 downto 0);
			reg_wb_data_chooser: std_logic;
		end record;

	constant zero_reg_wb_control : reg_wb_control :=
		(
			reg_wb_signal => '0',
			reg_wb_regs => (others=>'0'),
			reg_wb_data_chooser => '0'
		);

	type reg_other_control is
		record
			sp_wb_signal: std_logic;
			t_wb_signal: std_logic;
			ih_wb_signal: std_logic;
		end record;

	constant zero_reg_other_control : reg_other_control :=
		(
			sp_wb_signal => '0',
			t_wb_signal => '0',
			ih_wb_signal => '0'
		);

	type mem_control is
		record
			wb_signal: std_logic;
			wb_data_chooser: std_logic;
			read_signal: std_logic;
		end record;

	constant zero_mem_control : mem_control :=
		(
			wb_signal => '0',
			wb_data_chooser => '0',
			read_signal => '0'
		);

	type alu_control is
		record
			alu_op: std_logic_vector(2 downto 0);
			alu_src0: std_logic_vector(2 downto 0);  --0:rx, 1:sp, 2:0, 3:ih, 4:pc, 5:ry
			alu_src1: std_logic_vector(1 downto 0);  --0:ry, 1:immi, 2:rx, 3:0
			t_src: std_logic;
		end record;

	constant zero_alu_control : alu_control :=
		(
			alu_op => (others=>'0'),
			alu_src0 => (others=>'0'),
			alu_src1 => (others=>'0'),
			t_src => '0'
		);

	type jump_control is
		record
			B_signal: std_logic_vector(1 downto 0);
			B_com_chooser: std_logic_vector(1 downto 0);
			JR_signal: std_logic;
			pc_src: std_logic_vector(1 downto 0);
		end record;

	constant zero_jump_control: jump_control :=
		(
			B_signal => "00",
			B_com_chooser => "00",
			JR_signal => '0',
			pc_src => "00"
		);

	type forwarding_control is
		record
	        alu_forwarding_IDtoEXE_src0: std_logic;  --0:normal, 1: use forwarding
	        alu_forwarding_EXEtoMEM_src0: std_logic;
	        alu_forwarding_IDtoEXE_src1: std_logic;
	        alu_forwarding_EXEtoMEM_src1: std_logic;
			  alu_forwarding_t: std_logic_vector(1 downto 0);
			  alu_forwarding_sp: std_logic_vector(1 downto 0);
			  alu_forwarding_ih: std_logic_vector(1 downto 0);

			  alu_forwarding_EXEtoMEM_sel: std_logic; 	--only used when is mem, 0:aliu_result, 1: mem_data
		end record;

	constant zero_forwarding_control: forwarding_control :=
		(
	        alu_forwarding_IDtoEXE_src0 => '0',
	        alu_forwarding_EXEtoMEM_src0 => '0',
	        alu_forwarding_IDtoEXE_src1 => '0',
	        alu_forwarding_EXEtoMEM_src1 => '0',
			  alu_forwarding_t=> "00",
			  alu_forwarding_sp=> "00",
			  alu_forwarding_ih=> "00",

			  alu_forwarding_EXEtoMEM_sel => '0'
		);

	type bus_control is
		record
			rdn: std_logic;
			wrn: std_logic;
		end record;

	constant zero_bus_control: bus_control :=
		(
			rdn => '1',
			wrn => '1'
		);

	type ram_control is
		record
			oe: std_logic;
			we: std_logic;
			en: std_logic;
		end record;

	constant zero_ram_control: ram_control :=
		(
			oe => '1',
			we => '1',
			en => '1'
		);
		
	type vga_control is
		record
			vga_write: std_logic;
		end record;
	constant vga_control_zero: vga_control:= (
		vga_write => '0'
	);
	
	type point is
	record
		x: integer;
		y: integer;
	end record;

end utils;

package body utils is

end utils;
