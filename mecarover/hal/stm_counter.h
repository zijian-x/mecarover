/*
 * STM_counter.h
 *
 *  Created on: Nov 13, 2021
 *      Author: Fabia
 */
#pragma once

#include <tim.h>
#include "stm32f7xx_hal_tim.h"

class STMCounter {
public:
	STMCounter() = default;
	bool init(TIM_HandleTypeDef *htim, int id);
	uint64_t getCount(int id);

private:
	bool is_init = false;
};

