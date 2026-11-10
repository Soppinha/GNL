NAME			=	libgnl.a

# ********************************* OUTPUT ********************************** #

TAG			=	gnl
RESET		=	\033[0m
C_TAG		=	\033[1;34m
C_BUILD		=	\033[0;32m
C_DONE		=	\033[1;32m
C_CLEAN		=	\033[0;33m
C_RM		=	\033[0;31m
LOG			=	printf "$(C_TAG)%-12s$(RESET) %b%-10s$(RESET) %s\n" "[$(TAG)]"
SUBMAKE		=	$(MAKE) -s --no-print-directory -C

CC				=	cc
CFLAGS			=	-Wall -Wextra -Werror

SRC_DIR			=	src
OBJ_DIR			=	obj
INC_DIR			=	include

INCLUDES		=	-I$(INC_DIR)
HEADERS			=	$(INC_DIR)/get_next_line.h \
					$(INC_DIR)/get_next_line_bonus.h

SRC_FILES		=	get_next_line.c \
					get_next_line_utils.c

BONUS_FILES		=	get_next_line_bonus.c \
					get_next_line_utils_bonus.c

OBJS			=	$(addprefix $(OBJ_DIR)/, $(SRC_FILES:.c=.o))
BONUS_OBJS		=	$(addprefix $(OBJ_DIR)/, $(BONUS_FILES:.c=.o))

all: $(NAME)

$(NAME): $(OBJS)
	@rm -f $(NAME)
	@ar rcs $(NAME) $(OBJS)
	@$(LOG) "$(C_DONE)" archived "$(NAME) (mandatory)"

bonus: $(BONUS_OBJS)
	@rm -f $(NAME)
	@ar rcs $(NAME) $(BONUS_OBJS)
	@$(LOG) "$(C_DONE)" archived "$(NAME) (bonus)"

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS) | $(OBJ_DIR)
	@$(LOG) "$(C_BUILD)" compiling "$<"
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	@rm -rf $(OBJ_DIR)
	@$(LOG) "$(C_CLEAN)" cleaned objects

fclean: clean
	@rm -f $(NAME)
	@$(LOG) "$(C_RM)" removed "$(NAME)"

re: fclean all

.PHONY: all bonus clean fclean re
