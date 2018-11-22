library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.UTILS.ALL;

entity IDtoEXE is
	port (
--		clk: in std_logic;
--		in_reg1: in std_logic_vector(15 downto 0);
--		in_reg2: in std_logic_vector(15 downto 0);
--		in_control_Mem: in control_M_type;
--		in_control_WB: in control_WB_type;
--		in_control_EXE: in control_EXE_type;
--		in_imm_3_0: in std_logic_vector(3 downto 0);
--		in_imm_4_2: in std_logic_vector(2 downto 0);
--		in_imm_7_0: in std_logic_vector(7 downto 0);
--		in_RegDst_10_8: in std_logic_vector(2 downto 0);
--		in_RegDst_7_5: in std_logic_vector(2 downto 0);
--		in_RegDst_4_2: in std_logic_vector(2 downto 0);
--		
--		out_reg1: out std_logic_vector(15 downto 0);
--		out_reg2: out std_logic_vector(15 downto 0);
--		out_control_Mem: out control_M_type;
--		out_control_WB: out control_WB_type;
--		out_control_EXE: out control_EXE_type;
--		out_control_ALUSrc0: out std_logic_vector(2 downto 0);
--		out_control_ALUSrc1: out std_logic_vector(2 downto 0);
--		out_control_ALUOP: out std_logic_vector(2 downto 0);
--		out_control_RegDst: out std_logic_vector(1 downto 0);
--		out_imm_4_0: out std_logic_vector(4 downto 0);
--		out_imm_3_0: out std_logic_vector(3 downto 0);
--		out_imm_4_2: out std_logic_vector(2 downto 0);
--		out_imm_7_0: out std_logic_vector(7 downto 0);
--		out_RegDst_10_8: out std_logic_vector(2 downto 0);
--		out_RegDst_7_5: out std_logic_vector(2 downto 0);
--		out_RegDst_4_2: out std_logic_vector(2 downto 0)
	--in
		clk: in std_logic;
		rst: in std_logic;
		
		--control signal
		reg_wb_rx, reg_wb_ry, reg_wb_rz: in std_logic_vector(2 downto 0);
		reg_wb_signal_in: in std_logic;
		reg_wb_chooser: in std_logic_vector(1 downto 0);
		
		--alu
		alu_op_in: in std_logic_vector(2 downto 0);
		alu_src1_in: in std_logic_vector(1 downto 0);
		rx_in: in std_logic_vector(15 downto 0);
		ry_in: in std_logic_vector(15 downto 0);
		
		immi_7_0_in: in std_logic_vector(7 downto 0);
		immi_3_0_in: in std_logic_vector(3 downto 0);
		immi_4_0_in: in std_logic_vector(4 downto 0);
		immi_4_2_in: in std_logic_vector(2 downto 0);
		alu_src1_immi_chooser: in std_logic_vector(1 downto 0);
		alu_immi_extend: in std_logic;
	--out
		--control signal
		reg_wb_signal_out: out std_logic;
		reg_wb_place_out: out std_logic_vector(2 downto 0);
		
		--alu
		alu_op_out: out std_logic_vector(2 downto 0);
		alu_src1_out: out std_logic_vector(1 downto 0);
		rx_out: out std_logic_vector(15 downto 0);
		ry_out: out std_logic_vector(15 downto 0);
		
		--immi
		alu_immi_out: out std_logic_vector(15 downto 0)
	);
end IDtoEXE;

architecture Behavioral of IDtoEXE is
	component mux_3bit is
		port (
			input0: in std_logic_vector(15 downto 0);
			input1: in std_logic_vector(15 downto 0);
			input2: in std_logic_vector(15 downto 0);
			input3: in std_logic_vector(15 downto 0);
			input4: in std_logic_vector(15 downto 0);
			input5: in std_logic_vector(15 downto 0);
			input6: in std_logic_vector(15 downto 0);
			input7: in std_logic_vector(15 downto 0);
			sel: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(15 downto 0)
		);
	end component mux_3bit;
	
	component mux3_2bit is
		port (
			input0: in std_logic_vector(2 downto 0);
			input1: in std_logic_vector(2 downto 0);
			input2: in std_logic_vector(2 downto 0);
			input3: in std_logic_vector(2 downto 0);
			sel: in std_logic_vector(1 downto 0);
			output: out std_logic_vector(2 downto 0)
		);
	end component mux3_2bit;
	
	signal reg_wb_signal: std_logic;
	signal reg_wb_place, reg_wb_place_cand: std_logic_vector(2 downto 0);
	
	signal alu_op: std_logic_vector(2 downto 0);
	signal alu_src1: std_logic_vector(1 downto 0);
	signal rx, ry: std_logic_vector(15 downto 0);
	signal alu_immi, alu_immi_cand: std_logic_vector(15 downto 0);
	signal immi_7_0_sign, immi_7_0_zero, immi_3_0_sign, immi_3_0_zero, immi_4_0_sign, immi_4_0_zero, immi_4_2_sign, immi_4_2_zero: std_logic_vector(15 downto 0);
	signal immi_chooser_concat: std_logic_vector(2 downto 0);
begin
	reg_wb_signal_out <= reg_wb_signal;
	reg_wb_place_out <= reg_wb_place;
	
	alu_op_out <= alu_op;
	alu_src1_out <= alu_src1;
	rx_out <= rx;
	ry_out <= ry;
	
	alu_immi_out <= alu_immi;
	
	immi_7_0_sign(7 downto 0) <= immi_7_0_in;
	immi_7_0_sign(15 downto 8) <= (others=>immi_7_0_in(7));
	immi_7_0_zero <= "00000000" & immi_7_0_in;
	
	immi_3_0_zero <= "000000000000" & immi_3_0_in;
	immi_3_0_sign(3 downto 0) <= immi_3_0_in;
	immi_3_0_sign(15 downto 4) <= (others=> immi_3_0_in(3));
	
	immi_4_0_zero <= "00000000000" & immi_4_0_in;
	immi_4_0_sign(4 downto 0) <= immi_4_0_in;
	immi_4_0_sign(15 downto 5) <= (others=> immi_4_0_in(4));
	
	immi_4_2_zero <= "0000000000000" & immi_4_2_in;
	immi_4_2_sign(2 downto 0) <= immi_4_2_in;
	immi_4_2_sign(15 downto 3) <= (others=>immi_4_2_in(2));
	
	immi_chooser_concat <= alu_immi_extend & alu_src1_immi_chooser;
	immi_type_chooser: mux_3bit
		port map(
			input0=> immi_7_0_zero,
			input1=> immi_3_0_zero,
			input2=> immi_4_0_zero,
			input3=> immi_4_2_zero,
			input4=> immi_7_0_sign,
			input5=> immi_3_0_sign,
			input6=> immi_4_0_sign,
			input7=> immi_4_2_sign,
			sel=> immi_chooser_concat,
			output=> alu_immi_cand
		);
	
	wb_place_chooser: mux3_2bit
		port map(
			input0=> reg_wb_rx,
			input1=> reg_wb_ry,
			input2=> reg_wb_rz,
			input3=> "000",
			sel=> reg_wb_chooser,
			output=> reg_wb_place_cand
		);
	
	process(clk, rst)
	begin
	if rst = '0' then
		alu_op <= "000";
		alu_src1 <= "00";
		rx <= (others=>'0');
		ry <= (others=>'0');
		alu_immi <= (others=>'0');
	elsif rising_edge(clk) then
		reg_wb_signal <= reg_wb_signal_in;
		reg_wb_place <= reg_wb_place_cand;
		rx <= rx_in;
		ry <= ry_in;
		alu_immi <= alu_immi_cand;
		
		alu_op <= alu_op_in;
		alu_src1 <= alu_src1_in;
	end if;
	end process;
end Behavioral;
