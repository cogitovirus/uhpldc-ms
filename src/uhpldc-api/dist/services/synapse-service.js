"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getWorkspaces = getWorkspaces;
exports.listSqlPools = listSqlPools;
const azure_config_1 = require("../config/azure-config");
function getWorkspaces() {
    return __awaiter(this, void 0, void 0, function* () {
        return azure_config_1.synapseClient.workspaces.get(azure_config_1.resourceGroup, azure_config_1.workspaceName);
    });
}
function listSqlPools() {
    return __awaiter(this, void 0, void 0, function* () {
        return azure_config_1.synapseClient.sqlPools.listByWorkspace(azure_config_1.resourceGroup, azure_config_1.workspaceName);
    });
}
// Add more functions as needed
