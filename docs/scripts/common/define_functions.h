//関数名,     命令コード, 引数リスト, ...
NUM_INPUT,    NUM_INPUT,  idx, digit
PIC_INPUT,    PIC_INPUT,  picId, idx, digit
KANA_INPUT,   KANA_INPUT, kanaId
PANEL_INPUT,  PNL_INPUT,  panelId
KANA_INPUT,   KANA_INPUT, kanaId
WAIT,         WAIT,       sec
JUMP,         JUMP,       sceneId
ITEM_ADD,     ITEM_ADD,   itemId
ITEM_HAS,     ITEM_HAS,   itemId
ITEM_DEL,     ITEM_DEL,   itemId
ITEM_CHK,     ITEM_CHK,   itemId
CRAFT_CHK,    CRAFT_CHK,  itemId1, itemId2
COMPLETE,     COMPLETE,   
//draw_bg,    DRB,        id, effectId=0
//erase_bg,   ERB,        effectId=0
//draw_ch,    DRC,        id, pos, effectId=0
//erase_ch,   ERC,        id, effectId=0
//rand,       RAND,       start, end
//shake,      SHAKE,      ms, amp
//play_bgm,   BGMON,      id, fade=0, loop=0
//stop_bgm,   BGMOFF,     fade=0
//play_se,    SEON,       id, loop=1
//save,       SAVE,       slot=0
//load,       LOAD,       slot=0
//fullscreen, FULLSCREEN, flag=1
//set_var,    VARSET,     id, val
//add_var,    VARADD,     id, val
//get_var,    VARGET,     id
