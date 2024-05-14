----------------------------------------------------------------------------------
-- Company: Technical University of Cluj-Napoca 
-- Engineer: Cristian Vancea
-- 
-- Module Name: test_env - Behavioral
-- Description: 
--      MIPS 32, single-cycle
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
          outt : out STD_LOGIC_VECTOR (31 downto 0);
          outt2 : out STD_LOGIC_VECTOR (31 downto 0)
          );
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component IFetch
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR(31 downto 0);
           JumpAddress : in STD_LOGIC_VECTOR(31 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(31 downto 0);
           PCp4 : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component ID
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;    
           Instr : in STD_LOGIC_VECTOR(25 downto 0);
           WD : in STD_LOGIC_VECTOR(31 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR(31 downto 0);
           RD2 : out STD_LOGIC_VECTOR(31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR(31 downto 0);
           func : out STD_LOGIC_VECTOR(5 downto 0);
           sa : out STD_LOGIC_VECTOR(4 downto 0);
           rt : out STD_LOGIC_VECTOR(4 downto 0);
           rd : out STD_LOGIC_VECTOR(4 downto 0);
           reg_ver: out STD_LOGIC_VECTOR(31 downto 0);
           reg_ver2: out STD_LOGIC_VECTOR(31 downto 0);
           WriteAddress : in STD_LOGIC_VECTOR( 4 downto 0)
           );
end component;

component UC
    Port ( Instr : in STD_LOGIC_VECTOR(5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component EX is
    Port ( PCp4 : in STD_LOGIC_VECTOR(31 downto 0);
           RD1 : in STD_LOGIC_VECTOR(31 downto 0);
           RD2 : in STD_LOGIC_VECTOR(31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR(31 downto 0);
           func : in STD_LOGIC_VECTOR(5 downto 0);
           sa : in STD_LOGIC_VECTOR(4 downto 0);
           rt : in STD_LOGIC_VECTOR(4 downto 0);
           rd : in STD_LOGIC_VECTOR(4 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR(31 downto 0);
           ALURes : out STD_LOGIC_VECTOR(31 downto 0);
           Zero : out STD_LOGIC;
           RegDst : in STD_LOGIC;
           WriteAddress: out STD_LOGIC_VECTOR(4 downto 0));
end component;

component MEM
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR(31 downto 0);
           RD2 : in STD_LOGIC_VECTOR(31 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(31 downto 0);
           MemData3 : out STD_LOGIC_VECTOR(31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(31 downto 0));
end component;

signal Instruction : STD_LOGIC_VECTOR(31 downto 0);
signal MemData3 : STD_LOGIC_VECTOR(31 downto 0);


signal PC_plus_4 : STD_LOGIC_VECTOR(31 downto 0);  


signal RD1 : STD_LOGIC_VECTOR(31 downto 0); 

signal RD2 : STD_LOGIC_VECTOR(31 downto 0); 


signal WD : STD_LOGIC_VECTOR(31 downto 0); 

signal Ext_imm : STD_LOGIC_VECTOR(31 downto 0); 



signal JumpAddress, BranchAddress, ALURes, ALURes1, MemData : STD_LOGIC_VECTOR(31 downto 0);


signal func : STD_LOGIC_VECTOR(5 downto 0);

signal sa : STD_LOGIC_VECTOR(4 downto 0);
signal rt : STD_LOGIC_VECTOR(4 downto 0);
signal rd : STD_LOGIC_VECTOR(4 downto 0);
signal zero : STD_LOGIC;

signal digits : STD_LOGIC_VECTOR(31 downto 0);
signal en, rst, PCSrc : STD_LOGIC; 
-- main controls 
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(2 downto 0);

--1
signal Instruction_IF_ID : STD_LOGIC_VECTOR(31 downto 0);
signal PC_plus_4_IF_ID : STD_LOGIC_VECTOR(31 downto 0);  
signal rt_IF_ID : STD_LOGIC_VECTOR( 4 downto 0);
signal rd_IF_ID : STD_LOGIC_VECTOR( 4 downto 0);

--2
signal Instruction_ID_EX : STD_LOGIC_VECTOR(31 downto 0);
signal PC_plus_4_ID_EX : STD_LOGIC_VECTOR(31 downto 0);  
signal RD1_ID_EX : STD_LOGIC_VECTOR(31 downto 0); 
signal RD2_ID_EX : STD_LOGIC_VECTOR(31 downto 0); 
signal Ext_imm_ID_EX : STD_LOGIC_VECTOR(31 downto 0); 
signal sa_ID_EX : STD_LOGIC_VECTOR( 4 downto 0);
signal rt_ID_EX : STD_LOGIC_VECTOR( 4 downto 0);
signal rd_ID_EX : STD_LOGIC_VECTOR( 4 downto 0);
signal func_ID_EX : STD_LOGIC_VECTOR(5 downto 0);
signal MemtoReg_ID_EX: std_logic; 
signal RegWrite_ID_EX: std_logic; 
signal MemWrite_ID_EX: std_logic; 
signal Branch_ID_EX: std_logic; 
signal ALUOp_ID_EX: STD_LOGIC_VECTOR(2 downto 0);
signal ALUSrc_ID_EX: std_logic; 
signal RegDst_ID_EX: std_logic; 
signal WriteAddress_ID_EX: STD_LOGIC_VECTOR(4 downto 0); 

--3

signal MemtoReg_EX_MEM: std_logic; 
signal RegWrite_EX_MEM: std_logic; 
signal MemWrite_EX_MEM: std_logic; 
signal Branch_EX_MEM  : std_logic; 
signal zero_EX_MEM: std_logic;
signal WriteData_EX_MEM : STD_LOGIC_VECTOR(31 downto 0); 
signal BranchAddress_EX_MEM : STD_LOGIC_VECTOR(31 downto 0);
signal ALURes_EX_MEM: std_logic_vector(31 downto 0);
signal WD_EX_MEM: std_logic_vector(31 downto 0);
signal WriteAddress_EX_MEM: STD_LOGIC_VECTOR(4 downto 0); 

signal MemtoReg_MEM_WB: std_logic; 
signal RegWrite_MEM_WB: std_logic;
signal MemData_MEM_WB: STD_LOGIC_VECTOR(31 downto 0);
signal  ALURes_MEM_WB: std_logic_vector(31 downto 0); -- ?
signal WA_MEM_WB: std_logic_vector(31 downto 0);
signal WriteAddress_MEM_WB: STD_LOGIC_VECTOR(4 downto 0); 


signal reg_ver: std_logic_vector(31 downto 0);
signal reg_ver2: std_logic_vector(31 downto 0);
begin

  --  monopulse : MPG port map(en, btn(0), clk);
   en <= '1';
    -- main units
    inst_IFetch : IFetch port map(clk, btn(1), en, BranchAddress_EX_MEM, JumpAddress, Jump, PCSrc, Instruction, PC_plus_4);
    inst_ID : ID port map(clk, en, Instruction_IF_ID(25 downto 0), WD, RegWrite_MEM_WB, RegDst, ExtOp, RD1, RD2, Ext_imm, func, sa,rd,rt, reg_ver,reg_ver2,WriteAddress_MEM_WB);
    inst_UC : UC port map(Instruction_IF_ID(31 downto 26), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    inst_EX : EX port map(PC_plus_4_ID_EX, RD1_ID_EX, RD2_ID_EX, Ext_imm_ID_EX, func_ID_EX, sa_ID_EX,rt_ID_EX, rd_ID_EX, ALUSrc_ID_EX, ALUOp_ID_EX, BranchAddress, ALURes, Zero,RegDst_ID_EX,WriteAddress_ID_EX); 
    inst_MEM : MEM port map(clk, en, ALURes_EX_MEM, WD_EX_MEM, MemWrite_EX_MEM, MemData,MemData3, ALURes1);

    -- Write-Back unit 
    WD <= MemData_MEM_WB when MemtoReg_MEM_WB = '1' else ALURes_MEM_WB; 

    -- branch control
    PCSrc <= Zero_EX_MEM and Branch_EX_MEM;

    -- jump address
    JumpAddress <= PC_plus_4_IF_ID(31 downto 28) & Instruction_IF_ID(25 downto 0) & "00";

   -- SSD display MUX
--    with sw(7 downto 5) select
--        digits <=  Instruction when "000", 
--                   PC_plus_4 when "001",
--                   RD1 when "010",
--                   RD2 when "011",
--                   Ext_Imm when "100",
--                   ALURes when "101",
--                   MemData when "110",
--                   WD when "111",
--                   (others => 'X') when others; 
    
    process(clk)
    begin
    if en = '1' then
        if rising_edge(clk) then
             --IF/ID
        PC_plus_4_IF_ID <= PC_plus_4;
         Instruction_IF_ID <= Instruction;
         

        --ID/EX
        
         PC_plus_4_ID_EX <= PC_plus_4_IF_ID;        
         RD1_ID_EX  <= RD1;
         RD2_ID_EX  <= RD2;
         sa_ID_EX <= sa;
         Ext_imm_ID_EX <= Ext_imm;
         func_ID_EX <= func;
         rt_ID_EX <= rt;
         rd_ID_EX <= rd;
         MemtoReg_ID_EX <=Memtoreg;
         RegWrite_ID_EX <= RegWrite;
         MemWrite_ID_EX <= MemWrite;
         Branch_ID_EX <=Branch;
         ALUOp_ID_EX <= ALUOp;
         ALUSrc_ID_EX <= ALUSrc;
         RegDst_ID_EX <= RegDst;
         
         --EX/MEM
         
         MemtoReg_EX_MEM <= MemtoReg_ID_EX;
         RegWrite_EX_MEM <= RegWrite_ID_EX;
         MemWrite_EX_MEM <= MemWrite_ID_EX;
         Branch_EX_MEM <= Branch_ID_EX;
         zero_EX_MEM <= zero;
         BranchAddress_EX_MEM <=  BranchAddress;
         ALURes_EX_MEM <= ALURes;
         WD_EX_MEM <= RD2_ID_EX;
         WriteAddress_EX_MEM <= WriteAddress_ID_EX;
         
         --MEM/WB <=
         
         MemtoReg_MEM_WB <= MemtoReg_EX_MEM;
         RegWrite_MEM_WB <= RegWrite_EX_MEM;
         MemData_MEM_WB <= MemData;
         ALURes_MEM_WB <= ALURes_EX_MEM;
         WriteAddress_MEM_WB <= WriteAddress_EX_MEM;
         
        end if;
    end if;
    end process;    
    
    
    
  --  process(clk)
  --  begin
   --    if en = '1' then
    --       if rising_edge(clk) then
           --IF/
--PC_plus_4_IF_ID <= PC_plus_4;
       --         Instruction_IF_ID <= Instruction;
                
--               Instruction_ID_EX <= Instruction_IF_ID;
--               PC_plus_4_ID_EX <= PC_plus_4_IF_ID;
--               RD1_ID_EX : STD_LOGIC_VECTOR(31 downto 0); 
--               RD2_ID_EX : STD_LOGIC_VECTOR(31 downto 0); 
--               Ext_imm_ID_EX : STD_LOGIC_VECTOR(31 downto 0); 
--               MemtoReg_ID_EX: std_logic; 
--               RegWrite_ID_EX: std_logic; 
--               MemWrite_ID_EX: std_logic; 
--               Branch_ID_EX: std_logic; 
--               ALUOp_ID_EX: STD_LOGIC_VECTOR(2 downto 0);
--               ALUSrc_ID_EX: std_logic; 
--               RegDst_ID_EX: std_logic; 
                
   --     end if;
   --     end if;
  --  end process;
    
    outt <= Instruction;
    outt2 <= MemData3;
    display : SSD port map(clk, digits, an, cat);
    
    -- main controls on the leds
    led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
    
    --Pipeline registers:
    --1
  --  PC_plus_4_IF_ID <= PC_plus_4;
  --  Instruction_IF_ID <= Instruction;
    
end Behavioral;