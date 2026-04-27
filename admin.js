import http from './index'
import axios from 'axios'

// ===== 公共配置（无需认证） =====

export function fetchPlatformConfig() {
  return axios.get('/api/v1/public/config').then(res => {
    if (res.data && res.data.code === 0) return res.data.data
    return { platformName: '', dashboardTitle: '', dashboardSubtitle: '' }
  })
}

// ===== 列表查询 =====

export function listUsers(params) {
  return http.get('/admin/users', { params })
}

export function listOrders(params) {
  return http.get('/admin/adoption-orders', { params })
}

export function listCodes(params) {
  return http.get('/admin/adoption-codes', { params })
}

export function listPlots(params) {
  return http.get('/admin/plots', { params })
}

export function listDevices(params) {
  return http.get('/admin/actuator-devices', { params })
}

export function listTasks(params) {
  return http.get('/admin/operation-tasks', { params })
}

// ===== 创建操作 =====

export function createUser(data) {
  return http.post('/admin/users', data)
}

export function createOrder(data) {
  return http.post('/admin/adoption-orders', data)
}

export function createCode(data) {
  return http.post('/admin/adoption-codes', data)
}

export function createPlot(data) {
  return http.post('/admin/plots', data)
}

export function bindCamera(plotId, data) {
  return http.post(`/admin/plots/${plotId}/bind-camera`, data)
}

export function bindActuator(plotId, data) {
  return http.post(`/admin/plots/${plotId}/bind-actuator`, data)
}

export function bindSensor(plotId, data) {
  return http.post(`/admin/plots/${plotId}/bind-sensor`, data)
}

export function createCropBatch(plotId, data) {
  return http.post(`/admin/plots/${plotId}/crop-batches`, data)
}

export function bindScreen(plotId, data) {
  return http.post(`/admin/plots/${plotId}/bind-screen`, data)
}

export function listScreens(params) {
  return http.get('/admin/screens', { params })
}

export function deleteScreen(screenId) {
  return http.delete(`/admin/screens/${screenId}`)
}

export function regenerateScreenToken(screenId) {
  return http.post(`/admin/screens/${screenId}/regenerate-token`)
}

// ===== 设备数据查看 =====

export function getDeviceOverview() {
  return http.get('/admin/device-overview')
}

export function listSensorDevices(params) {
  return http.get('/admin/sensor-devices', { params })
}

export function listSensorData(sensorId, params) {
  return http.get(`/admin/sensor-devices/${sensorId}/data`, { params })
}

export function getPlotSensorOverview(plotId) {
  return http.get(`/admin/plots/${plotId}/sensor-overview`)
}

// ===== 摄像头管理 =====

export function listCameras(params) {
  return http.get('/admin/cameras', { params })
}

export function updateCamera(cameraId, data) {
  return http.put(`/admin/cameras/${cameraId}`, data)
}

export function deleteCamera(cameraId) {
  return http.delete(`/admin/cameras/${cameraId}`)
}

// ===== 状态变更 =====

export function updateOrderStatus(orderId, data) {
  return http.put(`/admin/adoption-orders/${orderId}/status`, data)
}

export function revokeCode(codeId, data) {
  return http.post(`/admin/adoption-codes/${codeId}/revoke`, data)
}

export function getDeviceDetail(deviceId) {
  return http.get(`/admin/actuator-devices/${deviceId}`)
}

export function unlockDevice(deviceId, data) {
  return http.post(`/admin/actuator-devices/${deviceId}/unlock`, data)
}

export function takeoverTask(taskId, data) {
  return http.post(`/admin/operation-tasks/${taskId}/takeover`, data)
}
