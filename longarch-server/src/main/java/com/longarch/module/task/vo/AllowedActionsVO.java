package com.longarch.module.task.vo;

import lombok.Data;

import java.util.List;

@Data
public class AllowedActionsVO {

    private Long plotId;
    private List<ActionItem> actions;

    @Data
    public static class ActionItem {
        private String actionType;
        private String actionName;
        private Boolean enabled;
        private String reason;

        /** 该动作在当前地块上默认对应的执行设备 (匹配 actionType.requiredDeviceType) */
        private Long deviceId;
        private String deviceName;

        /** 必填参数名 (前端据此建表单) · 例如 ["durationMinutes"] */
        private List<String> requiredParams;
        /** 可选参数名 · 例如 ["waterVolumeLiters", "flowRate"] */
        private List<String> optionalParams;
    }
}
